# Bootstrap Configuration

This directory contains the bootstrap Terraform configuration for initializing the tenant and setting up the remote Terraform state storage. This is the foundational step (day-0) that must be completed before deploying infrastructure.

## Structure

```
01_bootstrap/
├── day-0/          # Shared Terraform code (resource groups, storage account, Azure AD application, federated credentials, service principals, role assignments)
└── environments/   # Environment-specific variables
    ├── test/       # Test environment-specific variables
    │   ├── 00-config.auto.tfvars           # Provider configuration (subscription_id, tenant_id, client_id, use_oidc)
    │   ├── 00-parameters.auto.tfvars       # Environment-specific parameters
    │   └── backend-config-day-0.hcl        # Backend config for day-0 state file
    └── dev/        # Dev environment-specific variables
        ├── 00-config.auto.tfvars           # Provider configuration
        ├── 00-parameters.auto.tfvars       # Environment-specific parameters
        └── backend-config-day-0.hcl        # Backend config for day-0 state file
```

## What is the purpose of this step

> :information_source: **Note:** In this step, a remote Terraform state is being set up in Azure. This setup may not align with your specific requirements, so be prepared to make any necessary adjustments.

This step will allow us to automate all the further deployments. In a high overview, in this init the following are created:
- Storage account for Terraform state (`tfstate`)
- Azure Application
- [Federated credentials](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp) that will allow Terraform to [authenticate to Azure using a Service Principal with Open ID Connect](https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/guides/service_principal_oidc). It allows GitHub actions on the branch `main` to deploy and manage resource for this subscription. [More about Federated identity credentials](https://learn.microsoft.com/en-us/graph/api/resources/federatedidentitycredentials-overview?view=graph-rest-1.0)
- Service principal and role mapping

With this setup, the GitHub's `main` and `dev` branches will have right to access the tenant with `Contributor` role without defining any credentials in the repository. The OIDC token (JWT) that is created in the GitHub actions will be exchanged for Azure access token. Only tokens for `main` and `dev` branches will be allowed to be exchanged based on the [subject of the generated token](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect#filtering-for-a-specific-branch)

E.g.:
```
resource "azuread_application_federated_identity_credential" "github_actions_terraform_main" {
  ...
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:Unique-AG/hello-azure:ref:refs/heads/main"
}
```

## Prerequisites

Before proceeding, ensure you have the following:
- Tenant
- Subscription

## Usage

### Initializing Terraform Backend

The backend configuration must be passed via `-backend-config` flag during `terraform init`.

**Day-0 Initialization:**
```bash
cd day-0
terraform init -backend-config=../environments/test/backend-config-day-0.hcl
```

**Note:** The state file is stored at:
- Test: `terraform-init-test-v2.tfstate`
- Dev: `terraform-init-dev-v2.tfstate`

### Running Terraform Plan/Apply

Use `-var-file` to load environment-specific variables:

**Test Environment:**
```bash
cd day-0
terraform plan \
  -var-file=../environments/test/00-config.auto.tfvars \
  -var-file=../environments/test/00-parameters.auto.tfvars

terraform apply \
  -var-file=../environments/test/00-config.auto.tfvars \
  -var-file=../environments/test/00-parameters.auto.tfvars
```

**Dev Environment:**
```bash
cd day-0
terraform plan \
  -var-file=../environments/dev/00-config.auto.tfvars \
  -var-file=../environments/dev/00-parameters.auto.tfvars

terraform apply \
  -var-file=../environments/dev/00-config.auto.tfvars \
  -var-file=../environments/dev/00-parameters.auto.tfvars
```

### Environment-Specific Files

- **00-config.auto.tfvars**: Contains provider configuration (subscription_id, tenant_id, client_id, use_oidc) and backend configuration (resource_group_name, storage_account_name, container_name, key)
- **00-parameters.auto.tfvars**: Contains environment-specific parameters (tfstate_location)
- **backend-config-day-0.hcl**: Backend configuration for day-0 state file (resource_group_name, storage_account_name, container_name, key)

## Manual actions

The process consists of 2 phases - (1) initialization with local state file and (2) migrating the local state file to remote storage

### Phase 1: Initial Setup with Local State

First Terraform has to be run with local state file, since there is no remote storage for the state. For this, you need to temporarily modify `day-0/90-backend.tf` to use local backend:

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  # backend "azurerm" {
  #   # The backend configuration gets loaded from backend-config-day-0.hcl
  # }
}
```

Login manually to your tenant:
```bash
az login --tenant <<TENANT_ID>>
```

Navigate to day-0 and apply the Terraform changes:
```bash
cd day-0
terraform init
terraform apply \
  -var-file=../environments/test/00-config.auto.tfvars \
  -var-file=../environments/test/00-parameters.auto.tfvars
```

Next, populate the `client_id` in the environment's `00-config.auto.tfvars` from the newly created application:
```bash
var_value=$(terraform output client_id)
# MacOS
sed -i '' "s/\(client_id.*=\s*\).*/\1 $var_value/" ../environments/test/00-config.auto.tfvars
# Linux
sed -i "s/\(client_id.*=\s*\).*/\1 $var_value/" ../environments/test/00-config.auto.tfvars
# Windows
sed -i "s/\(client_id.*=\s*\).*/\1 $var_value/" ../environments/test/00-config.auto.tfvars
```

### Phase 2: Migrate to Remote State

Switch back to the `azurerm` backend in `day-0/90-backend.tf`:
```hcl
terraform {
  # backend "local" {
  #   path = "terraform.tfstate"
  # }

  backend "azurerm" {
    # The backend configuration gets loaded from backend-config-day-0.hcl
    # When running Terraform in GitHub Actions, the provider will detect the ACTIONS_ID_TOKEN_REQUEST_URL and ACTIONS_ID_TOKEN_REQUEST_TOKEN environment variables set by the GitHub Actions runtime
    # https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/guides/service_principal_oidc#oidc-token
  }
}
```

Now migrate the local state to the newly created storage in Azure:
```bash
cd day-0
terraform init -backend-config=../environments/test/backend-config-day-0.hcl -migrate-state
```

Now you are ready to make all the changes from within CI pipelines.

## Deployment Order

This bootstrap step (day-0) must be completed **before** deploying infrastructure:

1. **day-0 (Bootstrap)**: Initialize tenant and remote state storage
   - Creates storage account for Terraform state
   - Creates Azure AD application and service principal
   - Sets up federated credentials for GitHub Actions
   - Assigns necessary roles and permissions
   - State stored in: `terraform-init-test-v2.tfstate` (test) or `terraform-init-dev-v2.tfstate` (dev)

2. **02_infrastructure/day-1**: Deploy foundational infrastructure (depends on day-0)
3. **02_infrastructure/day-2**: Deploy identity/governance resources (depends on day-1)

## Resources Created

This bootstrap creates the following resources:

- **Resource Group**: For storing the Terraform state storage account
- **Storage Account**: For storing Terraform state files
- **Azure AD Application**: For Terraform authentication
- **Federated Identity Credentials**: For GitHub Actions OIDC authentication
- **Service Principal**: For Terraform to authenticate to Azure
- **Role Assignments**: Owner and User Access Administrator roles for the service principal
- **App Role Assignments**: Microsoft Graph API permissions (User.Read.All, Group.ReadWrite.All, RoleManagement.ReadWrite.Directory, Application.ReadWrite.All)

## Important Notes

- **Day-0 must be completed first**: All subsequent infrastructure deployments depend on the remote state storage and service principal created here
- **Separate state files**: Each environment (test/dev) uses its own state file
- **Client ID**: After Phase 1, the `client_id` must be updated in the environment's `00-config.auto.tfvars` file
- **OIDC Authentication**: The setup uses OpenID Connect for secure authentication without storing credentials

