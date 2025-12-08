# Test Environment Configuration

This directory contains environment-specific configuration files for the **test** environment.

## Files

- **`00-config-day-1.auto.tfvars`** - Day-1 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **`00-config-day-2.auto.tfvars`** - Day-2 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **`00-parameters-day-1.auto.tfvars`** - Day-1 environment-specific parameters (resource names, locations, user IDs, DNS settings, etc.)
- **`00-parameters-day-2.auto.tfvars`** - Day-2 environment-specific parameters (references to day-1 resources by name)
- **`backend-config-day-1.hcl`** - Backend configuration file for day-1 `terraform init -backend-config` (contains only backend settings)
- **`backend-config-day-2.hcl`** - Backend configuration file for day-2 `terraform init -backend-config` (contains only backend settings)

## Usage

These files are used with the day-1 and day-2 Terraform configurations:

```bash
# Initialize backend for day-1
cd ../../day-1
terraform init -backend-config=../environments/test/backend-config-day-1.hcl

# Plan/Apply day-1
terraform plan \
  -var-file=../environments/test/00-config-day-1.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-1.auto.tfvars

# Initialize backend for day-2
cd ../day-2
terraform init -backend-config=../environments/test/backend-config-day-2.hcl

# Plan/Apply day-2
terraform plan \
  -var-file=../environments/test/00-config-day-2.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-2.auto.tfvars
```

See the main [README.md](../README.md) for more details.
