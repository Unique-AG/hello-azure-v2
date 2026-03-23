terraform {

  backend "azurerm" {
    # Backend configuration must be passed via -backend-config flags during terraform init
    # Example: terraform init -backend-config=../test/backend-config.hcl
    # Or: terraform init -backend-config="resource_group_name=..." -backend-config="storage_account_name=..." etc.
    # When running Terraform in GitHub Actions, the provider will detect the ACTIONS_ID_TOKEN_REQUEST_URL and ACTIONS_ID_TOKEN_REQUEST_TOKEN environment variables set by the GitHub Actions runtime
    # https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/guides/service_principal_oidc#oidc-token
  }

}
