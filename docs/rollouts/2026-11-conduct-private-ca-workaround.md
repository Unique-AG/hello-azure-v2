# Workaround: Conduct egress gateway and upstream hosts signed by a private CA

**Status:** validated on a client DEV environment (release `2026.44.3`, hello-azure-v2 based). Interim
solution until `sbx-gateway` can take extra CA certificates as a chart value; remove it then (section 7).

**Applies to:** installations that followed the Conduct rollout (`docs/rollouts/2026-11-conduct.md`)
where a host the gateway proxies to, usually the public API host, has a certificate issued by a
private CA. Installations whose upstreams all use public CAs do not need this.

---

## 1. Symptom

The agent chats normally but files it produces never arrive. The gateway's audit log shows the upload
failing on TLS, not on policy:

```bash
kubectl -n sbx exec deploy/sbx-gateway -- tail -n 30 /var/log/egress-gateway/audit.jsonl
```

- `PUT /scoped/ingestion/upload` to your API host with `decision: error` and
  `Certificate verify failed: self-signed certificate in certificate chain` (or
  `unable to get local issuer certificate`)
- `Server TLS handshake failed` in the gateway log (`kubectl -n sbx logs deploy/sbx-gateway`)
- calls to the chat backend inside the cluster, Azure Blob and public package mirrors go through
  with `allow`

`decision: deny` is a different problem: the host, path or method is missing from the
`egressGateway` allow-list.

## 2. Why it happens

Only the gateway needs the CA. Sandboxes see certificates the gateway signs with its own MITM CA
(`Secret egress-mitm-ca`), which they already trust; only the gateway's connection to the real host
checks the real certificate.

The gateway is mitmproxy. It verifies upstream certificates against the `certifi` bundle shipped in
the image and ignores `SSL_CERT_FILE` and similar variables. Its `ssl_verify_upstream_trusted_ca`
option points it at a different CA file, and mitmproxy reads that option from `config.yaml` in its
config folder (`/home/app/.mitmproxy`) at startup.

> That option **replaces** `certifi`, it does not add to it. The CA file must contain the `certifi`
> bundle **and** your private CAs. With only your private CAs, your API host works and every public
> upstream (Blob, PyPI, package mirrors) stops verifying.

## 3. Prepare the CA bundle

You need the private **root CA** and the **issuing CA** that signed the host, as PEM files. These are
public certificates, not secrets.

Check which CA actually signed the host (the `issuer=` lines must match your files):

```bash
openssl s_client -connect <api host>:443 -servername <api host> -showcerts </dev/null
```

Build the bundle from the running gateway's own `certifi`, so it matches the image:

```bash
kubectl -n sbx exec deploy/sbx-gateway -- \
  cat /app/.venv/lib/python3.14/site-packages/certifi/cacert.pem > certifi.pem
cat certifi.pem private-root-ca.pem private-issuing-ca.pem > ca-bundle.pem
```

## 4. Repository changes

Two files under `03_applications/<env>/values/conduct/`.

**`sbx-common.yaml`**: add a ConfigMap to `resources`. Paste the whole `ca-bundle.pem` under
`ca-bundle.pem: |`, indented consistently. The file is about 300 KB, well under the ConfigMap limit.

```yaml
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: sbx-gateway-ca-bundle
      namespace: sbx
    data:
      config.yaml: |
        ssl_verify_upstream_trusted_ca: /home/app/.mitmproxy/ca-bundle.pem
      ca-bundle.pem: |
        -----BEGIN CERTIFICATE-----
        ...certifi bundle, then private root CA, then private issuing CA...
        -----END CERTIFICATE-----
```

**`sbx-gateway.yaml`**: mount both files into the mitmproxy config folder and let Reloader roll the
gateway when the ConfigMap changes:

```yaml
deployment:
  metadata:
    annotations:
      configmap.reloader.stakater.com/reload: 'sbx-gateway-config,sbx-gateway-ca-bundle'
  volumes:
    - name: sbx-gateway-ca-bundle
      configMap:
        name: sbx-gateway-ca-bundle
  volumeMounts:
    - name: sbx-gateway-ca-bundle
      mountPath: /home/app/.mitmproxy/ca-bundle.pem
      subPath: ca-bundle.pem
    - name: sbx-gateway-ca-bundle
      mountPath: /home/app/.mitmproxy/config.yaml
      subPath: config.yaml
```

Notes:

- Use `deployment.volumes` / `deployment.volumeMounts`, not the top-level `volumes` / `volumeMounts`.
  The chart appends the `deployment.*` lists to its own; setting the top-level lists replaces the
  chart's mounts (gateway config, MITM CA) and breaks the gateway.
- Keep `sbx-gateway-config` in the annotation: it is the chart's default and is replaced, not merged.
- The annotation matters: files mounted with `subPath` never receive ConfigMap updates, so without
  Reloader a new bundle only takes effect after a manual restart.
- The `egressGateway` allow-list does not change.

## 5. Apply

Both applications are `autoSync: false`. Sync in this order:

1. `sbx-common` (creates the ConfigMap)
2. `sbx-gateway` (rolls the pods with the new mounts)

## 6. Verify

The `python -c` commands are deliberately on one line; multi-line versions break when pasted.

```bash
# new pods running, config in place
kubectl -n sbx get pods -l app.kubernetes.io/name=sbx-gateway
kubectl -n sbx exec deploy/sbx-gateway -- cat /home/app/.mitmproxy/config.yaml

# the private host verifies against the bundle (prints TLSv1.2 or TLSv1.3)
kubectl -n sbx exec deploy/sbx-gateway -- /app/.venv/bin/python -c "import ssl,socket; h='<api host>'; c=ssl.create_default_context(cafile='/home/app/.mitmproxy/ca-bundle.pem'); print(c.wrap_socket(socket.create_connection((h,443)),server_hostname=h).version())"
```

Run the last command again with `h` set to your ingestion blob host and your package mirror (or
`pypi.org`) to prove public CAs still verify.

Then from the chat, in a Conduct space:

| Test | Prompt | Expected |
|---|---|---|
| File upload | "Create a small Excel file with three rows of sample data (name, city, amount) and give it to me as a downloadable file." | download link in the chat; audit log shows `allow` for `PUT <api host>/scoped/ingestion/upload` |
| Package install | "Install the Python package `pyfiglet` with pip in your sandbox, then print the word "Test" as ASCII art. Show me the full pip output." | `Successfully installed pyfiglet-…`; audit log shows `allow` for your package index |

The agent may first report that `pip` is missing and bootstrap it under `/tmp`. That is how the
sandbox image is built today and unrelated to this workaround.

**If it fails**

| What you see | Cause |
|---|---|
| gateway does not start, log shows `Cannot load trusted certificates` | the PEM is malformed (usually YAML indentation) or the path in `config.yaml` is wrong |
| still `self-signed certificate in certificate chain` | root CA missing from the bundle, or the pods did not restart: `kubectl -n sbx rollout restart deploy/sbx-gateway` |
| `unable to get local issuer certificate` | issuing CA missing from the bundle |
| public hosts fail after the change | the `certifi` part is missing from the bundle |
| `FileNotFoundError` in the verify command | ConfigMap not mounted: `sbx-gateway` was synced before `sbx-common`, or it has not rolled |

## 7. Maintenance and removal

- **Every `sbx-gateway` upgrade:** rebuild the `certifi` part of the bundle from the new image
  (section 3) and update the ConfigMap. A stale copy keeps working until a public CA changes, then
  public upstreams fail.
- **Private CA rotation:** replace the private part of the bundle. Reloader restarts the gateway.
- **Removal:** once the `sbx-gateway` chart accepts extra CA certificates as a value, move your root
  and issuing CA there, then delete the `sbx-gateway-ca-bundle` ConfigMap from `sbx-common.yaml` and the
  `deployment` block above from `sbx-gateway.yaml`. The chart then appends your CAs to the image's own
  `certifi`, so no copy has to be maintained.
