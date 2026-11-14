# Applications

## Overview

This repository contains Kubernetes applications organized into two sections:

- **System**: Responsible for core infrastructure services including CRDs, operators, Kong, and Zitadel
- **Chat**: Contains all FinanceGPT-specific services including frontend and backend components

## Deployment

All applications are deployed in a Kubernetes cluster and managed through ArgoCD.

## Installation

Installation requires just a single step - launching the `argo-bootstrap.yaml`:

```bash
# test environment
helmfile apply -e test -f argo-bootstrap.yaml.gotmpl
```

Alternatively, in this repository, you can simply run the `[test][bootstrap ArgoCD] 🐙` workflow.

## Testing the chat application (test environment)

1. **Prerequisites**
   - Argo CD has synced the chat apps (e.g. `backend-service-ingestion-worker-chat` is Healthy).
   - DNS for the test cluster is in place: `test-hello.azure.unique.dev`, `api.test-hello.azure.unique.dev`, `id.test-hello.azure.unique.dev`.
   - TLS certificates are issued (cert-manager + Kong ingress).

2. **Open the chat UI**
   - In a browser go to: **https://test-hello.azure.unique.dev/chat**
   - You will be redirected to Zitadel (IdP) at **https://id.test-hello.azure.unique.dev** to sign in.
   - After login you are redirected back to the chat app.

3. **Optional: check API and pods**
   - Chat API base: `https://api.test-hello.azure.unique.dev/chat`
   - With `kubectl` (context set to the test cluster):
     - `kubectl get pods -n unique -l app.kubernetes.io/name=backend-service-ingestion-worker-chat`
     - `kubectl get pods -n unique -l app.kubernetes.io/name=backend-service-chat`
   - Quick API reachability (no auth): `curl -sI https://api.test-hello.azure.unique.dev/chat` (may return 401/403 without a token).

## Gatekeeper (Access Control 2.0)

Gatekeeper is the authorization service behind Access Control 2.0. The backend services ask it whether a user may perform an action. It runs from the dedicated `helm/gatekeeper` OCI chart (mirrored into the
environment ACR) as the `gatekeeper` Argo CD application, with its own PostgreSQL database (`database-url-gatekeeper` in the sensitive Key Vault, created by `02_infrastructure/day-2`).

Background for operators: the PUBDOC pages *Gatekeeper Service Architecture* and *Access Management for Admins*.

| File | Purpose |
| --- | --- |
| `defaults/backend-services/gatekeeper.yaml` | Environment-agnostic defaults: `report_only`, resources, RabbitMQ, Scope Management / Chat dependencies |
| `<env>/values/backend-services/gatekeeper.yaml` | Image, `ADMIN_ROOT_COMPANY_ID` / `ADMIN_ROOT_USER_ID`, Key Vault, hostname |
| `<env>/apps/chat/gatekeeper.yaml` | Argo CD application (sync wave 6, after Scope Management) |
| `defaults/backend-services/*.yaml` | Consumers: `GATEKEEPER_API_URL` + `GATEKEEPER_RUNNING_MODE` |
| `<env>/values/web-apps/_all.yaml` | `GATEKEEPER_BACKEND_API_URL` for the admin Access Management UI |

### Running modes

Gatekeeper and every consumer run in **`report_only`**: each decision is evaluated and logged, but access is always allowed. Users see no change. `disabled` (the default when the variable is unset) skips the check. `enforce` denies what the policies deny.

Always set `GATEKEEPER_API_URL` together with a non-`disabled` mode. While the URL is set, Zitadel role changes are synced into Gatekeeper even in `disabled` mode, which keeps policies current for a later switch.

### Sync order

The applications are `autoSync: false`. Sync them in this order:

1. `backend-service-scope-management` is **Healthy**.
2. Sync `gatekeeper`. Its pre-sync hook Job runs `prisma migrate deploy` and then the one-time data
   migration, which calls Scope Management for every company, user, group and access. Allow **at least
   20 minutes** on the first sync and do not interrupt it.
3. Sync the consumers (`backend-service-*`, `reflector`) and `web-app-admin`. Reloader restarts pods on
   ConfigMap changes; otherwise run `kubectl -n unique rollout restart deployment/<name>`.

### Health checks

```bash
kubectl -n unique get pods -l app.kubernetes.io/name=gatekeeper            # Ready
kubectl -n unique get jobs | grep gatekeeper                               # migration Job completed
curl -s https://api.<your-api-host>/gatekeeper/probe                       # 200 + version
kubectl -n unique logs deploy/backend-service-chat | grep -i gatekeeper    # report_only decisions, no connection errors
```

Change a user's role in Zitadel and check that `updateUserRolesFromZitadel` appears in the Gatekeeper logs
(scope-management forwards the Zitadel event).

### Moving to `enforce` (later, separate change)

1. Run in `report_only` long enough to review the logged deny decisions, and fix the policies they reveal.
2. Switch **all** consumers and Gatekeeper to `enforce` in one change. Use `GATEKEEPER_ENFORCE_COMPANIES`
   (comma-separated company IDs) on the consumers to roll out company by company.
3. **Never** set scope-management to `enforce` before Gatekeeper's data migration has completed. Gatekeeper's
   migration calls scope-management, which would then call Gatekeeper and deny: a circular deadlock.
4. The admin UI flags `FEATURE_FLAG_NEW_ACCESS_CONTROL_UI_UN_11268` and
   `FEATURE_FLAG_ENABLE_GATEKEEPER_PERMISSIONS_UN_15116` (`defaults/_flags.yaml`) stay `"false"` until then.

To roll back, set `GATEKEEPER_RUNNING_MODE: "disabled"` on the consumers; also remove `GATEKEEPER_API_URL` to disconnect them from Gatekeeper completely.

## Troubleshooting

### "no active client not found" when opening the chat app

This error appears when the chat web app tries to restore the session (silent sign-in / refresh token) but the **OIDC client** it uses is not registered or does not match the **test** Zitadel instance. The values in the repo (`ZITADEL_CLIENT_ID`, `ZITADEL_PROJECT_ID`) are placeholders and must match an application created in the **test** Zitadel.

**Steps to fix:**

1. **Open Zitadel Console (test)**
   Go to **https://id.test-hello.azure.unique.dev** and sign in with the Zitadel admin user (e.g. the FirstInstance user from your Zitadel config).

2. **Get the correct IDs**
   - In Zitadel: go to your **Project** (e.g. "Cluster IAM" or "unique") and note the **Project ID** (numeric).
   - Open the **Application** used by the chat web app (e.g. "unique-app" or "chat"). Note the **Client ID** (numeric).
   - If the application does not exist, create a **User Agent** (or **Web**) application and set:
     - **Redirect URIs**: `https://test-hello.azure.unique.dev/chat`, `https://test-hello.azure.unique.dev/chat/` (and add any callback path your app uses, e.g. `/chat/callback` if applicable).
     - **Post-logout redirect URI** if needed (e.g. `https://test-hello.azure.unique.dev/chat`).
     - **Auth Method**: PKCE is typical for SPAs; no client secret.

3. **Update the repo with the real IDs**
   - In `03_applications/test/values/web-apps/_all.yaml` set:
     - `ZITADEL_CLIENT_ID` to the Application **Client ID** from Zitadel.
     - `ZITADEL_PROJECT_ID` to the **Project ID** from Zitadel.
   - Keep `ZITADEL_ISSUER` as `https://id.test-hello.azure.unique.dev`.
   - If Kong or other services use the same project for JWT validation, update `ZITADEL_PROJECT_ID` in:
     - `03_applications/test/values/backend-services/_all.yaml`
     - `03_applications/test/values/kong/kong-cluster-plugins.yaml` (e.g. `zitadel_project_id`)
     - `03_applications/test/values/ai-services/assistants-core.yaml`
     so they all match the same Zitadel project.

4. **Redeploy and retry**
   - Commit, push, and sync the chat web app (and any apps that use the updated Kong/backend config).
   - Clear site data for `test-hello.azure.unique.dev` or use a private/incognito window, then open **https://test-hello.azure.unique.dev/chat** again.
