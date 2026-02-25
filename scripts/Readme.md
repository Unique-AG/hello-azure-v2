# Scripts

This directory contains helper scripts for Terraform development workflows. These scripts are used by pre-commit hooks and CI/CD pipelines.

## Prerequisites

- **Terraform CLI** - Required for `tf-fmt.sh`
- **Docker** - Required for `tf-docs.sh` and `tf-sec.sh` (docker mode)
- **terraform-docs** - Required for `tf-docs.sh` (native mode), auto-installed if missing
- **tfsec** - Required for `tf-sec.sh` (native mode), auto-installed if missing

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

### tf-sec.sh

Runs [tfsec](https://github.com/aquasecurity/tfsec) security scanner on the Terraform codebase.

**Usage:**

```bash
# Docker mode (default - for CI/CD or environments with Docker)
./scripts/tf-sec.sh docker
./scripts/tf-sec.sh          # same as docker

# Native mode (for WSL2 or local development without Docker)
./scripts/tf-sec.sh native
```

**Modes:**

| Mode | Description | Use Case |
|------|-------------|----------|
| `docker` | Runs tfsec via Docker container | CI/CD pipelines, Docker-enabled environments |
| `native` | Runs tfsec binary directly | WSL2, local development, environments without Docker |

**What it does:**
- Scans Terraform code for security issues
- Uses configuration from `.github/configs/tfsec.yaml`
- In GitHub Actions, outputs results in SARIF format for security tab integration
- In native mode, automatically installs tfsec if not found

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
      - id: tf-sec
        name: tf-sec
        entry: scripts/tf-sec.sh
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
pre-commit run tf-sec --all-files
```

## WSL2 Users

If you're using WSL2 without Docker Desktop, use native mode for tf-docs and tf-sec:

```bash
# Run manually
./scripts/tf-docs.sh native
./scripts/tf-sec.sh native

# Or temporarily update .pre-commit-config.yaml:
# entry: scripts/tf-docs.sh native
# entry: scripts/tf-sec.sh native
```
