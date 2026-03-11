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
# dev environment
helmfile apply -e dev -f argo-bootstrap.yaml.gotmpl
# test environment
helmfile apply -e test -f argo-bootstrap.yaml.gotmpl
```

Alternatively, in this repository, you can simply run the `[dev][bootstrap ArgoCD] 🐙` or `[test][bootstrap ArgoCD] 🐙` workflow.

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
