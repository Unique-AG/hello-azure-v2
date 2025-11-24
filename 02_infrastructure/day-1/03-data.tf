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

# Kubernetes cluster data source (will be populated after AKS cluster is created)
# Note: This will fail if cluster doesn't exist, but that's expected during initial setup
# The cluster will be created in a later phase
data "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.core.name
  depends_on          = [var.cluster_id] # Required for AGIC identity access. Note: This may cause role assignments to be recreated on plan, but is necessary for AGIC to function properly.
}

