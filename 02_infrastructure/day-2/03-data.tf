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

# Key Vault data sources (created in day-1)
data "azurerm_key_vault" "key_vault_core" {
  name                = local.key_vault_core_computed.name
  resource_group_name = local.key_vault_core_computed.resource_group_name
}

data "azurerm_key_vault" "key_vault_sensitive" {
  name                = local.key_vault_sensitive_computed.name
  resource_group_name = local.key_vault_sensitive_computed.resource_group_name
}

# Resource Group data sources (created in day-1)
data "azurerm_resource_group" "core" {
  name = var.resource_group_core_name
}

data "azurerm_resource_group" "sensitive" {
  name = var.resource_group_sensitive_name
}

data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name_vnet
}

# Kubernetes cluster data source (created in day-1 or workloads)
# Note: This will fail if cluster doesn't exist, but that's expected during initial setup
data "azurerm_kubernetes_cluster" "cluster" {
  name                = local.aks_computed.name
  resource_group_name = local.aks_computed.resource_group_name
}

# DNS Zone data source (created in day-1)
data "azurerm_dns_zone" "dns_zone" {
  name                = local.dns_zone_computed.name
  resource_group_name = local.dns_zone_computed.resource_group_name
}

