# Scripts

This directory contains helper scripts for Terraform development workflows. These scripts are used by pre-commit hooks and CI/CD pipelines.

## Prerequisites

- **Terraform CLI** - Required for `tf-fmt.sh`
- **Docker** - Required for `tf-docs.sh` and `trivy.sh` (docker mode)
- **terraform-docs** - Required for `tf-docs.sh` (native mode), auto-installed if missing
- **Trivy** - Required for `trivy.sh` (native mode); use the version pinned in the script

## Scripts

### tf-docs.sh

Generates documentation for Terraform modules using [terraform-docs](https://terraform-docs.io).

**Usage:**

```bash
# Docker mode (default - for CI/CD or environments with Docker)
./scripts/tf-docs.sh docker
./scripts/tf-docs.sh          # same as docker

# Native mode (for WSL2 or local development without Docker)
./scripts/tf-docs.sh native
```

**Modes:**

| Mode | Description | Use Case |
|------|-------------|----------|
| `docker` | Runs terraform-docs via Docker container | CI/CD pipelines, Docker-enabled environments |
| `native` | Runs terraform-docs binary directly | WSL2, local development, environments without Docker |

**Notes:**
- Searches for `tfdocs.yaml` config files in the repository
- Excludes `.terraform/` directories (downloaded module dependencies)
- In native mode, automatically installs terraform-docs if not found

### tf-fmt.sh

Formats all Terraform files using `terraform fmt`.

**Usage:**

```bash
./scripts/tf-fmt.sh
```

**What it does:**
- Recursively formats all `.tf` files in:
  - `01_bootstrap/`
  - `02_infrastructure/`
  - `03_applications/`

### trivy.sh

Runs [Trivy](https://trivy.dev) against this repository's own code. Findings inside the downloaded
terraform-modules are excluded (they can only be fixed in that shared repository). Accepted findings live in
`.trivyignore.yaml`, each with its reason.

**Usage:**

```bash
./scripts/trivy.sh config          # Terraform misconfigurations; fails on HIGH/CRITICAL (default)
./scripts/trivy.sh secret          # committed secrets; fails on HIGH/CRITICAL
./scripts/trivy.sh sarif           # all severities as trivy-results.sarif (CI uploads it to code scanning)
./scripts/trivy.sh config native   # use a local trivy binary instead of the pinned image
```

The Docker image is pinned by digest: the Trivy 0.69.4 release and the trivy-action tags were compromised in
March 2026.

### Other CI checks

The lint workflow (`.github/workflows/tf.validate.yaml`) also runs actionlint, zizmor (config:
`.github/zizmor.yml`) and TFLint with the azurerm ruleset (config: `.tflint.hcl`, run per Terraform root).

## Pre-commit Integration

These scripts are configured as pre-commit hooks in `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: tf-docs
        name: tf-docs
        entry: scripts/tf-docs.sh
        language: script
        pass_filenames: false
      - id: tf-fmt
        name: tf-fmt
        entry: scripts/tf-fmt.sh
        language: script
        pass_filenames: false
      - id: trivy
        name: trivy (Terraform misconfigurations)
        entry: scripts/trivy.sh config
        language: script
        pass_filenames: false
```

### Installing Pre-commit Hooks

```bash
# Install pre-commit (if not already installed)
pip install pre-commit

# Install hooks for this repository
pre-commit install
```

### Running Hooks Manually

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run a specific hook
pre-commit run tf-docs --all-files
pre-commit run tf-fmt --all-files
pre-commit run trivy --all-files
```

## WSL2 Users

If you're using WSL2 without Docker Desktop, use native mode for tf-docs and trivy:

```bash
# Run manually
./scripts/tf-docs.sh native
./scripts/trivy.sh config native

# Or temporarily update .pre-commit-config.yaml:
# entry: scripts/tf-docs.sh native
# entry: scripts/trivy.sh config native
```
