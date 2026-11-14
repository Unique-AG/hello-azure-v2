# Rollout guide: Gatekeeper (Access Control 2.0) on the Hello Azure reference setup

**Status:** draft. The changes are in the repository; they have not yet been applied and verified on the
reference `test` environment. This note will be updated once they are.

**Applies to:** an existing Hello Azure installation on platform release `2026.44.3` or later, with Argo CD
managed applications under `03_applications`.

This adds a new service and changes configuration on existing ones. **Nothing is blocked**: Gatekeeper and
every service that calls it start in `report_only`, which evaluates and logs each authorization decision but
always allows access. Switching to `enforce` is a later, separate step (see
[`03_applications/README.md`](../../03_applications/README.md#gatekeeper-access-control-20)).

---

## 1. What changes

| Layer | Change | File |
| --- | --- | --- |
| Infrastructure | New PostgreSQL database `gatekeeper`; the module writes `database-url-gatekeeper` into the sensitive Key Vault | `02_infrastructure/day-2/01-variables.tf` (`postgresql_databases`) |
| Mirroring | Image `unique/gatekeeper` and OCI chart `helm/gatekeeper` | `mirroring/<env>/app.unique.yaml` |
| Applications | New Argo CD app `gatekeeper` (sync wave 6) | `03_applications/<env>/apps/chat/gatekeeper.yaml` |
| | Gatekeeper defaults and environment overlay | `03_applications/defaults/backend-services/gatekeeper.yaml`, `03_applications/<env>/values/backend-services/gatekeeper.yaml` |
| | `GATEKEEPER_API_URL` + `GATEKEEPER_RUNNING_MODE: report_only` on chat, ingestion, ingestion-worker(-chat), scope-management (incl. `user-sync`), app-repository, configuration, webhook-worker, webhook-scheduler, event-socket, speech, client-insights-exporter, reflector | `03_applications/defaults/backend-services/*.yaml` |
| | `GATEKEEPER_BACKEND_API_URL` for the admin web app | `03_applications/<env>/values/web-apps/_all.yaml` |
| | Access Management UI flags listed explicitly as `"false"` (no behaviour change) | `03_applications/defaults/_flags.yaml` |

No new workload identity is needed: Gatekeeper reads Key Vault through the CSI driver with the existing
VM managed identity, like the other backend services.

## 2. Values to fill in for your environment

Copy `03_applications/test/values/backend-services/gatekeeper.yaml` to your environment and set:

| Value | What to put |
| --- | --- |
| `image.registry`, `image.tag` | Your ACR and platform release |
| `env.ADMIN_ROOT_COMPANY_ID` | Your Zitadel root organization ID (same as scope-management `ZITADEL_ROOT_ORG_ID`) |
| `env.ADMIN_ROOT_USER_ID` | An ID that is **not** a real user. It is the internal root caller and gets every permission |
| `env.ZITADEL_PROJECT_ID`, `CORS_ALLOWED_ORIGINS`, `UNIQUE_INSTALLATION_ID` | Same values as in `<env>/values/backend-services/_all.yaml` |
| `secretProvider.*` | Same values as in `<env>/values/backend-services/_all.yaml` |
| `postgresql.connection.url.fromSecretProvider.vault` | Your sensitive Key Vault |
| `routes.hostname` | Your API hostname |

The chart refuses to render if `ADMIN_ROOT_*` or `routes.hostname` are missing.

## 3. Rollout steps

1. **Infrastructure.** Apply `02_infrastructure/day-2`. The plan should only add the `gatekeeper` database
   and its Key Vault secret. Check:
   `az keyvault secret show --vault-name <sensitive-kv> -n database-url-gatekeeper --query id`
2. **Mirror.** Run the Unique artifacts mirroring workflow and confirm `unique/gatekeeper` and
   `helm/gatekeeper` exist in your ACR.
3. **Gatekeeper.** Merge the application changes. With `backend-service-scope-management` Healthy, sync
   `gatekeeper`. The hook Job runs the Prisma migration and then the one-time data migration, which reads
   all companies, users, groups and accesses from Scope Management. Allow at least 20 minutes.
4. **Consumers.** Sync the backend services, `reflector` and `web-app-admin`.

## 4. Verification

| Check | How | Expected |
| --- | --- | --- |
| Pod | `kubectl -n unique get pods -l app.kubernetes.io/name=gatekeeper` | Ready |
| Migration hook | Logs of the gatekeeper hook Job | Prisma migrate and data migration completed |
| Probe | `curl https://<api-host>/gatekeeper/probe` | 200 with version |
| Consumers | Logs of chat, ingestion, scope-management | `report_only` decisions logged, no Gatekeeper connection errors |
| Identity sync | Change a user's role in Zitadel | `updateUserRolesFromZitadel` in the Gatekeeper logs |
| No user impact | Log in, chat, upload a file, open admin | Everything works as before |

## 5. Rollback

- **Stop evaluating:** set `GATEKEEPER_RUNNING_MODE: "disabled"` on the consumers and sync them.
- **Disconnect completely:** also remove `GATEKEEPER_API_URL` from the consumers. Then the `gatekeeper`
  application can be deleted. Keep the database unless you are sure you will not re-enable Gatekeeper;
  re-creating it means running the data migration again.
