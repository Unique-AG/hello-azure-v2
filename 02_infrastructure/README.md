# Infrastructure Configuration

This directory contains the infrastructure Terraform configurations organized by deployment phase (day-1, day-2) and environment-specific variables.

## Structure

```
02_infrastructure/
├── day-1/          # Foundational infrastructure (resource groups, networking, managed identities, custom roles)
├── day-2/          # Identity/governance resources (Azure AD groups, application registration, federated credentials)
├── environments/test/           # Test environment-specific variables
│   ├── 00-config-day-1.auto.tfvars      # Day-1 provider & backend configuration
│   ├── 00-config-day-2.auto.tfvars      # Day-2 provider & backend configuration
│   ├── 00-parameters-day-1.auto.tfvars  # Day-1 environment-specific parameters
│   ├── 00-parameters-day-2.auto.tfvars  # Day-2 environment-specific parameters
│   ├── backend-config-day-1.hcl         # Backend config for day-1 terraform init
│   └── backend-config-day-2.hcl         # Backend config for day-2 terraform init
└── environments/dev/            # Dev environment-specific variables
    ├── 00-config-day-1.auto.tfvars      # Day-1 provider & backend configuration
    ├── 00-config-day-2.auto.tfvars      # Day-2 provider & backend configuration
    ├── 00-parameters-day-1.auto.tfvars  # Day-1 environment-specific parameters
    ├── 00-parameters-day-2.auto.tfvars  # Day-2 environment-specific parameters
    ├── backend-config-day-1.hcl         # Backend config for day-1 terraform init
    └── backend-config-day-2.hcl         # Backend config for day-2 terraform init
```

## Usage

### Considerations When Using Terraform Cloud

In case of using Terraform Cloud, when creating Terraform Cloud workspace, you should take into account the following:
- Workspace execution mode should be configured for "Agent" instead of "Remote". Specifying the "Remote" execution mode instructs HCP Terraform to perform Terraform runs on its own disposable virtual machines, so "Agent" execution mode is requred for Terraform Cloud to have access to the Azure subscription.
- Workspace variables should be configured for the environment-specific variables and point to the correct backend configuration file f.e. `/environments/<env>/00-config-day-1.auto.tfvars` and `/environments/<env>/00-parameters-day-1.auto.tfvars` for both day-1 and day-2 respectively.
- You will probably need to remove use_oidc and client_id from the 91-providers.tf file as they are not needed for Terraform Cloud and add organization and workspaces block to the terraform block in the 90-backend.tf file.

### Initializing Terraform Backend

Each day-X configuration uses a **separate state file** to avoid conflicts. The backend configuration must be passed via `-backend-config` flags during `terraform init`.

**Day-1 Initialization:**
```bash
cd day-1
terraform init -backend-config=../environments/test/backend-config-day-1.hcl
```

**Day-2 Initialization:**
```bash
cd day-2
terraform init -backend-config=../environments/test/backend-config-day-2.hcl
```

**Note:** Each day-X has its own state file:
- day-1: `terraform-day-1-test.tfstate` (test) or `terraform-day-1-dev.tfstate` (dev)
- day-2: `terraform-day-2-test.tfstate` (test) or `terraform-day-2-dev.tfstate` (dev)

This ensures state isolation and prevents conflicts between different deployment phases.

### Running Terraform Plan/Apply

Use `-var-file` to load environment-specific variables. Each day-X has its own parameters file:

**Day-1 (Foundational Infrastructure):**
```bash
cd day-1
terraform plan \
  -var-file=../environments/test/00-config-day-1.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-1.auto.tfvars

terraform apply \
  -var-file=../environments/test/00-config-day-1.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-1.auto.tfvars
```

**Day-2 (Identity/Governance):**
```bash
cd day-2
terraform plan \
  -var-file=../environments/test/00-config-day-2.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-2.auto.tfvars

terraform apply \
  -var-file=../environments/test/00-config-day-2.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-2.auto.tfvars
```

**Important:** Day-2 must be deployed **after** day-1, as it references resources created in day-1 using data sources (by name and resource group).

### Environment-Specific Files

- **00-config-day-1.auto.tfvars**: Contains day-1 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **00-config-day-2.auto.tfvars**: Contains day-2 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **00-parameters-day-1.auto.tfvars**: Contains day-1 environment-specific parameters (resource names, locations, user IDs, etc.)
- **00-parameters-day-2.auto.tfvars**: Contains day-2 environment-specific parameters (references to day-1 resources by name)
- **backend-config-day-1.hcl**: Backend configuration for day-1 terraform init (contains only backend settings, used with `-backend-config` flag)
- **backend-config-day-2.hcl**: Backend configuration for day-2 terraform init (contains only backend settings, used with `-backend-config` flag)

## Deployment Order

1. **day-1**: Deploy foundational infrastructure first
   - Creates resource groups, key vaults, networking, managed identities, etc.
   - State stored in: `terraform-day-1-test.tfstate` (test) or `terraform-day-1-dev.tfstate` (dev)

2. **day-2**: Deploy identity/governance resources (depends on resources from day-1)
   - Uses data sources to look up day-1 resources by name and resource group
   - Creates Azure AD groups, application registrations, federated credentials
   - State stored in: `terraform-day-2-test.tfstate` (test) or `terraform-day-2-dev.tfstate` (dev)

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
terraform init -backend-config=../environments/dev/backend-config-day-1.hcl
cd day-2
terraform init -backend-config=../environments/dev/backend-config-day-2.hcl
```
for test environment:
```bash
cd day-1
terraform init -backend-config=../environments/test/backend-config-day-1.hcl
cd day-2
terraform init -backend-config=../environments/test/backend-config-day-2.hcl
```

## Import scripts:
- day-1/import_azure_resources.sh
- day-2/import_azure_resources.sh

for dev environment:
```bash
cd day-1
terraform init -backend-config=../environments/dev/backend-config-day-1.hcl
# will output the log to import_azure_resources.log and console
bash ./import_azure_resources.sh | tee import_azure_resources.log
```

```bash
cd day-2
terraform init -backend-config=../environments/dev/backend-config-day-2.hcl
# will output the log to import_azure_resources.log and console
bash ./import_azure_resources.sh | tee import_azure_resources.log
```

for test environment:
```bash
cd day-1
terraform init -backend-config=../environments/test/backend-config-day-1.hcl
# will output the log to import_azure_resources.log and console
bash ./import_azure_resources.sh | tee import_azure_resources.log
```

```bash
cd day-2
terraform init -backend-config=../environments/test/backend-config-day-2.hcl
# will output the log to import_azure_resources.log and console
bash ./import_azure_resources.sh | tee import_azure_resources.log
```

### Finall you can run terraform plan to verify the import
```bash
cd day-1
terraform plan -var-file=../environments/test/00-config-day-1.auto.tfvars -var-file=../environments/test/00-parameters-day-1.auto.tfvars
```

```bash
cd day-2
terraform plan -var-file=../environments/test/00-config-day-2.auto.tfvars -var-file=../environments/test/00-parameters-day-2.auto.tfvars
```

### Important Notes

- **Day-1 must be imported before day-2**: Day-2 resources depend on resources created in day-1 (e.g., key vaults, resource groups)
- **Separate state files**: Each day-X uses its own state file:
  - Day-1: `terraform-day-1-test.tfstate` (test) or `terraform-day-1-dev.tfstate` (dev)
  - Day-2: `terraform-day-2-test.tfstate` (test) or `terraform-day-2-dev.tfstate` (dev)
- **Idempotent**: The import scripts will skip resources that are already in state
- **Expected drifts**: After import, running `terraform plan` will show cosmetic drifts (API version differences, module-internal changes). These are safe and documented in the script output

## Post-Deployment: Application Configuration Updates

After a fresh deployment (day-1 + day-2), certain application configuration files under `03_applications/` must be updated with values from the Terraform outputs before running the ArgoCD bootstrap. These values are environment-specific and change with each new deployment.

### Required Updates

#### 1. cert-manager ClusterIssuer (`03_applications/<env>/values/cert-manager/cluster-issuer.yaml`)

The ClusterIssuer uses the **kubelet identity** (Managed Service Identity on AKS nodes) to authenticate with Azure DNS for Let's Encrypt DNS-01 challenges. After deploying day-2, update the `clientID` field with the kubelet identity's client ID.

**How to get the value:**
```bash
cd day-2
terraform output cluster_kublet_client_id
```

**What to update:**
```yaml
managedIdentity:
  clientID: <cluster_kublet_client_id output value>
```

**Why it's needed:** cert-manager creates DNS TXT records (`_acme-challenge.*`) in the Azure DNS zone to prove domain ownership for Let's Encrypt certificate issuance. The kubelet identity is already granted the `DNS Zone Contributor` role on the DNS zone by Terraform (see `day-2/25-role-assignments.tf`), so no additional role assignments are needed.

#### 2. Azure Key Vault Secrets Store CSI Driver (`03_applications/<env>/values/argo/argo-azure-entra-secret.yaml`)

The CSI driver identity must be the **client ID** of the `azurekeyvaultsecretsprovider-*` addon identity (not the object ID).

**How to get the value:**
```bash
az aks show -g <resource-group> -n <cluster-name> \
  --query "addonProfiles.azureKeyvaultSecretsProvider.identity.clientId" -o tsv
```

**What to update:**
```yaml
keeper:
  identityId: <CSI addon identity client ID>
```

#### 3. External Secrets & Backend Services identity references

Files that reference `userAssignedIdentityID` or `identityId` should use the same CSI addon identity client ID from step 2:
- `03_applications/<env>/values/external-secrets/secret-store.yaml`
- `03_applications/<env>/values/backend-services/_all.yaml`
- `03_applications/<env>/values/ai-services/assistants-core.yaml`

### Deployment Checklist (Fresh Environment)

1. Deploy **day-1** infrastructure (`terraform apply`)
2. Deploy **day-2** infrastructure (`terraform apply`)
3. Update application configs with Terraform outputs:
   - `cluster-issuer.yaml` → `cluster_kublet_client_id`
   - `argo-azure-entra-secret.yaml` → CSI addon identity client ID
   - `secret-store.yaml`, `_all.yaml`, `assistants-core.yaml` → CSI addon identity client ID
4. Run **ArgoCD bootstrap** workflow
5. Verify cert-manager issues TLS certificates (`kubectl get certificate -n unique`)
6. Verify ArgoCD UI is accessible via HTTPS

