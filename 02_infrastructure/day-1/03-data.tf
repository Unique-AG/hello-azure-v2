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
