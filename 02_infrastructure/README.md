# Infrastructure Configuration

This directory contains the infrastructure Terraform configurations organized by deployment phase (day-1, day-2) and environment-specific variables.

## Structure

```
02_infrastructure/
├── day-1/          # Foundational infrastructure (resource groups, networking, managed identities, custom roles)
├── day-2/          # Identity/governance resources (Azure AD groups, application registration, federated credentials)
├── test/           # Test environment-specific variables
│   ├── 00-config.auto.tfvars           # Provider configuration (subscription_id, tenant_id, client_id, use_oidc)
│   ├── 00-parameters-day-1.auto.tfvars        # Day-1 environment-specific parameters
│   ├── 00-parameters-day-2.auto.tfvars  # Day-2 environment-specific parameters
│   ├── backend-config-day-1.hcl         # Backend config for day-1 (separate state file)
│   └── backend-config-day-2.hcl         # Backend config for day-2 (separate state file)
└── dev/            # Dev environment-specific variables
    ├── 00-config.auto.tfvars           # Provider configuration
    ├── 00-parameters-day-1.auto.tfvars        # Day-1 environment-specific parameters
    ├── 00-parameters-day-2.auto.tfvars  # Day-2 environment-specific parameters
    ├── backend-config-day-1.hcl         # Backend config for day-1
    └── backend-config-day-2.hcl         # Backend config for day-2
```

## Usage

### Initializing Terraform Backend

Each day-X configuration uses a **separate state file** to avoid conflicts. The backend configuration must be passed via `-backend-config` flags during `terraform init`.

**Day-1 Initialization:**
```bash
cd day-1
terraform init -backend-config=../test/backend-config-day-1.hcl
```

**Day-2 Initialization:**
```bash
cd day-2
terraform init -backend-config=../test/backend-config-day-2.hcl
```

**Note:** Each day-X has its own state file:
- day-1: `terraform-infra-v2-day-1.tfstate`
- day-2: `terraform-infra-v2-day-2.tfstate`

This ensures state isolation and prevents conflicts between different deployment phases.

### Running Terraform Plan/Apply

Use `-var-file` to load environment-specific variables. Each day-X has its own parameters file:

**Day-1 (Foundational Infrastructure):**
```bash
cd day-1
terraform plan \
  -var-file=../test/00-config.auto.tfvars \
  -var-file=../test/00-parameters-day-1.auto.tfvars

terraform apply \
  -var-file=../test/00-config.auto.tfvars \
  -var-file=../test/00-parameters-day-1.auto.tfvars
```

**Day-2 (Identity/Governance):**
```bash
cd day-2
terraform plan \
  -var-file=../test/00-config.auto.tfvars \
  -var-file=../test/00-parameters-day-2.auto.tfvars

terraform apply \
  -var-file=../test/00-config.auto.tfvars \
  -var-file=../test/00-parameters-day-2.auto.tfvars
```

**Important:** Day-2 must be deployed **after** day-1, as it references resources created in day-1 using data sources (by name and resource group).

### Environment-Specific Files

- **00-config.auto.tfvars**: Contains provider configuration (subscription_id, tenant_id, client_id, use_oidc) - used by both day-1 and day-2
- **00-parameters-day-1.auto.tfvars**: Contains day-1 environment-specific parameters (resource names, locations, user IDs, etc.)
- **00-parameters-day-2.auto.tfvars**: Contains day-2 environment-specific parameters (references to day-1 resources by name)
- **backend-config-day-1.hcl**: Backend configuration for day-1 (separate state file)
- **backend-config-day-2.hcl**: Backend configuration for day-2 (separate state file)

## Deployment Order

1. **day-1**: Deploy foundational infrastructure first
   - Creates resource groups, key vaults, networking, managed identities, etc.
   - State stored in: `terraform-infra-v2-day-1.tfstate`

2. **day-2**: Deploy identity/governance resources (depends on resources from day-1)
   - Uses data sources to look up day-1 resources by name and resource group
   - Creates Azure AD groups, application registrations, federated credentials
   - State stored in: `terraform-infra-v2-day-2.tfstate`

## Cross-Day Dependencies

Day-2 does **not** use `terraform_remote_state` to reference day-1. Instead, it uses **data sources** to look up resources by name:

```hcl
# Day-2 looks up resources created in day-1
data "azurerm_key_vault" "key_vault_sensitive" {
  name                = var.key_vault_sensitive.name
  resource_group_name = var.key_vault_sensitive.resource_group_name
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = var.aks.name
  resource_group_name = var.aks.resource_group_name
}
```

This approach provides:
- **Loose coupling**: Day-2 doesn't depend on day-1 state
- **Independent deployment**: Day-2 can be deployed once resources exist
- **Resilience**: Works even if day-1 state is lost/recreated

## Importing Existing Resources

If you have existing resources in Azure that need to be imported into Terraform state, use the import scripts. The import process is split across day-1 and day-2 to match the separate state files.
Please note that you need to initialize terraform state before running the import scripts.
e.g.

for dev environment:
```bash
cd day-1
terraform init -backend-config=../dev/backend-config-day-1.hcl
cd day-2
terraform init -backend-config=../dev/backend-config-day-2.hcl
```
for test environment:
```bash
cd day-1
terraform init -backend-config=../test/backend-config-day-1.hcl
cd day-2
terraform init -backend-config=../test/backend-config-day-2.hcl
```



## Import scripts:
- day-1/import_azure_resources.sh
- day-2/import_azure_resources.sh

```bash
cd day-1
terraform init -backend-config=../test/backend-config-day-1.hcl
./import_azure_resources.sh
```

```bash
cd day-2
terraform init -backend-config=../test/backend-config-day-2.hcl
./import_azure_resources.sh
```

### Important Notes

- **Day-1 must be imported before day-2**: Day-2 resources depend on resources created in day-1 (e.g., key vaults, resource groups)
- **Separate state files**: Each day-X uses its own state file:
  - Day-1: `terraform-infra-v2-day-1.tfstate`
  - Day-2: `terraform-infra-v2-day-2.tfstate`
- **Idempotent**: The import scripts will skip resources that are already in state
- **Expected drifts**: After import, running `terraform plan` will show cosmetic drifts (API version differences, module-internal changes). These are safe and documented in the script output

