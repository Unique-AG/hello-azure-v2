# Data sources for referencing existing Azure resources
data "azurerm_subscription" "current" {}

# Role definitions for custom roles
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
}

# Azure AD data sources
data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_user" "gitops_maintainer" {
  for_each  = toset(var.gitops_maintainer_user_ids)
  object_id = each.value
}

# Data source to look up users
data "azuread_user" "keyvault_secret_writer" {
  for_each  = toset(var.keyvault_secret_writer_user_ids)
  object_id = each.value
}

# Terraform Service Principal - needed for Key Vault role assignments
# Uses object_id to uniquely identify the SP (multiple SPs may have the same display name)
# To find the correct object_id, run: az ad sp list --display-name "terraform" --query "[].{objectId:id,displayName:displayName}" -o table
data "azuread_service_principal" "terraform" {
  object_id = var.terraform_service_principal_object_id
}
