# Infrastructure Configuration

This directory contains the infrastructure Terraform configurations organized by deployment phase (day-1, day-2, day-3) and environment-specific variables.

## Structure

```
02_infrastructure/
├── day-1/          # Foundational infrastructure (resource groups, networking, managed identities, custom roles)
├── day-2/          # Identity/governance resources (Azure AD groups, application registration, federated credentials)
├── day-3/          # Secure access resources (Azure Bastion host for secure RDP/SSH access)
├── environments/test/           # Test environment-specific variables
│   ├── 00-config-day-1.auto.tfvars      # Day-1 provider & backend configuration
│   ├── 00-config-day-2.auto.tfvars      # Day-2 provider & backend configuration
│   ├── 00-config-day-3.auto.tfvars      # Day-3 provider & backend configuration
│   ├── 00-parameters-day-1.auto.tfvars  # Day-1 environment-specific parameters
│   ├── 00-parameters-day-2.auto.tfvars  # Day-2 environment-specific parameters
│   ├── 00-parameters-day-3.auto.tfvars  # Day-3 environment-specific parameters
│   ├── backend-config-day-1.hcl         # Backend config for day-1 terraform init
│   ├── backend-config-day-2.hcl         # Backend config for day-2 terraform init
│   └── backend-config-day-3.hcl         # Backend config for day-3 terraform init
└── environments/dev/            # Dev environment-specific variables
    ├── 00-config-day-1.auto.tfvars      # Day-1 provider & backend configuration
    ├── 00-config-day-2.auto.tfvars      # Day-2 provider & backend configuration
    ├── 00-config-day-3.auto.tfvars      # Day-3 provider & backend configuration
    ├── 00-parameters-day-1.auto.tfvars  # Day-1 environment-specific parameters
    ├── 00-parameters-day-2.auto.tfvars  # Day-2 environment-specific parameters
    ├── 00-parameters-day-3.auto.tfvars  # Day-3 environment-specific parameters
    ├── backend-config-day-1.hcl         # Backend config for day-1 terraform init
    ├── backend-config-day-2.hcl         # Backend config for day-2 terraform init
    └── backend-config-day-3.hcl         # Backend config for day-3 terraform init
```

## Usage

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

**Day-3 Initialization:**
```bash
cd day-3
terraform init -backend-config=../environments/test/backend-config-day-3.hcl
```

**Note:** Each day-X has its own state file:
- day-1: `terraform-infra-v2-day-1.tfstate`
- day-2: `terraform-infra-v2-day-2.tfstate`
- day-3: `terraform-infra-v2-day-3.tfstate`

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

**Day-3 (Secure Access - Azure Bastion):**
```bash
cd day-3
terraform plan \
  -var-file=../environments/test/00-config-day-3.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-3.auto.tfvars

terraform apply \
  -var-file=../environments/test/00-config-day-3.auto.tfvars \
  -var-file=../environments/test/00-parameters-day-3.auto.tfvars
```

**Important:** 
- Day-2 must be deployed **after** day-1, as it references resources created in day-1 using data sources (by name and resource group).
- Day-3 must be deployed **after** day-1, as it requires the VNET and AzureBastionSubnet created in day-1, as well as the Log Analytics workspace for diagnostics.

### Environment-Specific Files

- **00-config-day-1.auto.tfvars**: Contains day-1 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **00-config-day-2.auto.tfvars**: Contains day-2 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **00-config-day-3.auto.tfvars**: Contains day-3 provider and backend configuration (subscription_id, tenant_id, client_id, use_oidc, backend settings)
- **00-parameters-day-1.auto.tfvars**: Contains day-1 environment-specific parameters (resource names, locations, user IDs, etc.)
- **00-parameters-day-2.auto.tfvars**: Contains day-2 environment-specific parameters (references to day-1 resources by name)
- **00-parameters-day-3.auto.tfvars**: Contains day-3 environment-specific parameters (references to day-1 resources by name, bastion configuration)
- **backend-config-day-1.hcl**: Backend configuration for day-1 terraform init (contains only backend settings, used with `-backend-config` flag)
- **backend-config-day-2.hcl**: Backend configuration for day-2 terraform init (contains only backend settings, used with `-backend-config` flag)
- **backend-config-day-3.hcl**: Backend configuration for day-3 terraform init (contains only backend settings, used with `-backend-config` flag)

## Deployment Order

1. **day-1**: Deploy foundational infrastructure first
   - Creates resource groups, key vaults, networking (including AzureBastionSubnet), managed identities, Log Analytics workspace, etc.
   - State stored in: `terraform-infra-v2-day-1.tfstate`

2. **day-2**: Deploy identity/governance resources (depends on resources from day-1)
   - Uses data sources to look up day-1 resources by name and resource group
   - Creates Azure AD groups, application registrations, federated credentials
   - State stored in: `terraform-infra-v2-day-2.tfstate`

3. **day-3**: Deploy secure access resources (depends on resources from day-1)
   - Uses data sources to look up day-1 resources by name and resource group
   - Creates Azure Bastion host with Standard SKU, tunneling, and native client support
   - Configures diagnostic logging to Log Analytics workspace
   - State stored in: `terraform-infra-v2-day-3.tfstate`

## Cross-Day Dependencies

Day-2 and Day-3 do **not** use `terraform_remote_state` to reference day-1. Instead, they use **data sources** to look up resources by name:

```hcl
# Day-2 looks up resources created in day-1
data "azurerm_key_vault" "key_vault_sensitive" {
  name                = var.key_vault_sensitive.name
  resource_group_name = var.key_vault_sensitive.resource_group_name
}

# Day-3 looks up resources created in day-1
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name_vnet
}

data "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name_vnet
}

data "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_workspace_name
  resource_group_name = var.resource_group_core_name
}
```

This approach provides:
- **Loose coupling**: Day-2 and Day-3 don't depend on day-1 state
- **Independent deployment**: Day-2 and Day-3 can be deployed once resources exist
- **Resilience**: Works even if day-1 state is lost/recreated

## Importing Existing Resources

If you have existing resources in Azure that need to be imported into Terraform state, use the import scripts. The import process is split across day-1, day-2, and day-3 to match the separate state files.
Please note that you need to initialize terraform state before running the import scripts.
e.g.

for dev environment:
```bash
cd day-1
terraform init -backend-config=../environments/dev/backend-config-day-1.hcl
cd day-2
terraform init -backend-config=../environments/dev/backend-config-day-2.hcl
cd day-3
terraform init -backend-config=../environments/dev/backend-config-day-3.hcl
```
for test environment:
```bash
cd day-1
terraform init -backend-config=../environments/test/backend-config-day-1.hcl
cd day-2
terraform init -backend-config=../environments/test/backend-config-day-2.hcl
cd day-3
terraform init -backend-config=../environments/test/backend-config-day-3.hcl
```

## Import scripts:
- day-1/import_azure_resources.sh
- day-2/import_azure_resources.sh
- day-3/import_azure_resources.sh (if needed)

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

```bash
cd day-3
terraform init -backend-config=../environments/dev/backend-config-day-3.hcl
# Import script would go here if needed
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

```bash
cd day-3
terraform init -backend-config=../environments/test/backend-config-day-3.hcl
# Import script would go here if needed
```

### Important Notes

- **Day-1 must be imported before day-2 and day-3**: Day-2 and Day-3 resources depend on resources created in day-1 (e.g., key vaults, resource groups, VNET, Log Analytics workspace)
- **Separate state files**: Each day-X uses its own state file:
  - Day-1: `terraform-infra-v2-day-1.tfstate`
  - Day-2: `terraform-infra-v2-day-2.tfstate`
  - Day-3: `terraform-infra-v2-day-3.tfstate`
- **Idempotent**: The import scripts will skip resources that are already in state
- **Expected drifts**: After import, running `terraform plan` will show cosmetic drifts (API version differences, module-internal changes). These are safe and documented in the script output

## Day-3: Azure Bastion

Day-3 deploys Azure Bastion, a fully managed PaaS service that provides secure RDP/SSH connectivity to your virtual machines directly through the Azure Portal without exposing them to the internet.

### Features

- **Standard SKU**: Required for production use and native client support
- **Tunneling Enabled**: Allows kubectl port forwarding and secure port forwarding to other services
- **Native Client Support (IP Connect)**: Enables direct SSH/RDP connections from native clients without browser
- **Diagnostic Logging**: All connection attempts and sessions are logged to Log Analytics workspace for audit and security monitoring
- **Azure RBAC**: Access control is managed through Azure RBAC roles (Azure Bastion Reader, Azure Bastion Contributor)

### Security Considerations

- **No NSG on AzureBastionSubnet**: Azure manages security for this subnet automatically. Use Azure RBAC for access control instead.
- **Subnet Requirements**: The subnet must be named exactly `AzureBastionSubnet` (case-sensitive) and be at least `/26` in size (64 IP addresses).
- **Public IP**: Standard SKU public IP is required for Standard Bastion SKU.

### Prerequisites

- Day-1 must be deployed first, as it creates:
  - The VNET with AzureBastionSubnet
  - Resource groups
  - Log Analytics workspace for diagnostics

### Usage Example: Connecting to AKS via Azure Bastion

Azure Bastion provides secure access to resources in your VNET, including the ability to run `kubectl` commands against your AKS cluster. The most common approach is to use a jumpbox VM, but port forwarding is also possible.

#### Prerequisites for kubectl Access

1. **Azure CLI** installed and authenticated:
   ```bash
   az login
   ```

2. **Azure Bastion** deployed (day-3) with tunneling enabled

3. **AKS cluster** deployed and accessible from within the VNET

4. **Jumpbox VM** (optional but recommended) - A Linux VM in the same VNET as your AKS cluster

#### Method 1: Using a Jumpbox VM (Recommended)

This is the simplest and most common approach. Connect to a jumpbox VM via Azure Bastion and run kubectl commands directly from the VM.

1. **Connect to your jumpbox VM via Azure Bastion**:
   
   **Via Azure Portal**:
   - Navigate to your VM in the Azure Portal
   - Click "Connect" → "Bastion"
   - Enter your credentials and connect
   
   **Via Azure CLI** (if native client support is enabled):
   ```bash
   az network bastion ssh \
     --name bastion-ha-test \
     --resource-group resource-group-core \
     --target-resource-id <VM_RESOURCE_ID> \
     --auth-type password \
     --username azureuser
   ```

2. **Install kubectl and Azure CLI on the VM** (if not already installed):
   ```bash
   # Install Azure CLI
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   
   # Install kubectl
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```

3. **Authenticate with Azure** (on the VM):
   ```bash
   az login
   ```

4. **Get AKS cluster credentials**:
   ```bash
   # For test environment
   az aks get-credentials \
     --resource-group resource-group-core \
     --name aks-test \
     --admin

   # For dev environment
   az aks get-credentials \
     --resource-group resource-group-core \
     --name aks-dev \
     --admin
   ```

5. **Run kubectl commands**:
   ```bash
   kubectl get nodes
   ```

#### Method 2: Port Forwarding via Azure Bastion (Advanced)

If you need to run kubectl from your local machine, you can set up port forwarding through Azure Bastion. This requires a VM in the VNET to act as a jump host.

1. **Get the AKS cluster credentials** (on your local machine):
   ```bash
   az aks get-credentials \
     --resource-group resource-group-core \
     --name aks-test \
     --admin
   ```

2. **Get the AKS API server address**:
   ```bash
   AKS_API_SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}' | sed 's|https://||')
   echo "AKS API Server: ${AKS_API_SERVER}"
   ```

3. **Set up port forwarding through a VM via Azure Bastion**:
   ```bash
   # Connect to VM via Bastion and set up port forwarding
   az network bastion ssh \
     --name bastion-ha-test \
     --resource-group resource-group-core \
     --target-resource-id <VM_RESOURCE_ID> \
     --auth-type password \
     --username azureuser \
     --ssh-command "ssh -L 8443:${AKS_API_SERVER}:443 -N localhost"
   ```

4. **Update kubeconfig to use the tunnel**:
   ```bash
   kubectl config set-cluster $(kubectl config current-context) \
     --server https://127.0.0.1:8443 \
     --insecure-skip-tls-verify=true
   ```

5. **Run kubectl commands**:
   ```bash
   kubectl get nodes
   ```

#### Important Notes

- The SSH tunnel must remain active while using kubectl. Keep the terminal session open.
- Replace `bastion-ha-test` with your actual bastion name (format: `{bastion_name}-{name_prefix}-{env}`)
- Replace `aks-test` with your actual cluster name (format: `{cluster_name}-{env}`)
- The `--insecure-skip-tls-verify` flag is used for the tunnel; the actual connection to AKS is still secure through Bastion
- For production, consider using Azure RBAC integration with AKS for better security
- Ensure your user has the necessary Azure RBAC permissions: `Azure Bastion Reader` role to connect, and appropriate AKS permissions to access the cluster

