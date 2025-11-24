# Test Environment Configuration

This directory contains environment-specific configuration files for the **test** environment.

## Files

- **`00-config.auto.tfvars`** - Backend and provider configuration (subscription_id, tenant_id, client_id, use_oidc, and backend settings)
- **`00-parameters.auto.tfvars`** - Environment-specific parameters (resource names, locations, user IDs, DNS settings, etc.)
- **`backend-config.hcl`** - Backend configuration file for `terraform init -backend-config` (contains only backend settings)

## Usage

These files are used with the day-1 and day-2 Terraform configurations:

```bash
# Initialize backend
cd ../day-1
terraform init -backend-config=../test/backend-config-day-1.hcl

# Plan/Apply
terraform plan \
  -var-file=../test/00-config.auto.tfvars \
  -var-file=../test/00-parameters.auto.tfvars
```

See the main [README.md](../README.md) for more details.
