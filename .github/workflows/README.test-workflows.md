# Test Workflows

How the `test` environment is changed from this repository.

## Environments

GitHub environments map to the infrastructure layers. Every environment is trusted by the same Entra app
(`6d1d8c4b-…`, federated credentials in `01_bootstrap/day-0/40-federated-credentials.tf`):

- **00-init**: day-0 (Terraform state, the CI identity, subscription settings)
- **10-pm**: day-1, gh-test, day-2, day-3 (network, Key Vaults, AKS, App Gateway, data services, Bastion)
- **20-wl**: workloads (image mirroring, Argo CD bootstrap, Helm)

## Terraform: `test.terraform.yaml`

Plan on pull request, apply on merge, for every layer.

- **Pull request**: plans the changed layers and every layer downstream of them, and posts one sticky comment per
  layer. Downstream: day-0 → all; day-1 → day-1, gh-test, day-2, day-3; day-2 → day-2, day-3.
- **Push to `main`** (a merge): plans and applies the same layers in order day-0 → day-1 → gh-test and day-2 →
  day-3. Each job applies exactly the plan it just made.
- **Foundation guard**: day-0, day-1 and gh-test are hard to re-create. If their plan on `main` deletes or replaces
  anything, the job stops before apply. Run such a change by dispatch with `confirm` = `apply-foundation`.
- **Manual dispatch**: choose `layers` (`all` or a comma-separated list). On `main` it applies; on any other branch
  it only plans.
- **Required check**: the `terraform` job sums up the layer jobs; it passes when nothing needed to run.
- **Pull requests from forks** get no Azure login, so no layer runs for them.
- **Kill switch**: `gh workflow disable test.terraform.yaml` (re-enable with `gh workflow enable`).
- The laptop fallback (Operator apply) is described in `02_infrastructure/README.md`.

The steps of one layer live in the composite action `.github/actions/terraform`.

## Lint and security: `tf.validate.yaml`

Runs on every pull request and push to `main`: Terraform format and docs, Trivy (misconfigurations and secrets;
fails on HIGH/CRITICAL), actionlint, zizmor and TFLint. Its `lint` job is a required check.

## Workloads (environment `20-wl`)

**`test.mirror-public-artifacts.yaml`**: mirrors public container images (Docker Hub, GHCR, Quay.io) to the
Azure Container Registry `uqhacrtest`. Needs day-2 (the ACR). Currently commented out (needs ACR login and qcli
setup).

**`test.mirror-unique-artifacts.yaml`**: mirrors Unique container images to `uqhacrtest`. Needs day-2 and the
`UNIQUECR_PASSWORD` secret.

**`test.argocd-bootstrap.yaml`**: bootstraps Argo CD in the AKS cluster. Run it manually with action `apply`
after the cluster exists and the images are mirrored. It calls the reusable `test.helm.yaml` with
`03_applications/argo-bootstrap.yaml.gotmpl`.

**`test.helm.yaml`**: reusable workflow (`workflow_call` only) for helmfile template, diff and sync.

## Order for a new environment

```
test.terraform.yaml (dispatch, layers=all)       day-0 → day-1 → gh-test, day-2 → day-3
   ↓
test.mirror-public-artifacts.yaml  ┐
test.mirror-unique-artifacts.yaml  ┘ can run in parallel
   ↓
test.argocd-bootstrap.yaml (action=apply)
```

day-0's first create is a one-time local bootstrap (`01_bootstrap/README.md`): the CI identity it creates is what
the pipeline signs in with.
