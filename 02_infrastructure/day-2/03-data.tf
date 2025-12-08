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

// Key Vault data sources (created in day-1)
data "azurerm_key_vault" "key_vault_core" {
  name                = local.key_vault_core.name
  resource_group_name = local.key_vault_core.resource_group_name
}

data "azurerm_key_vault" "key_vault_sensitive" {
  name                = local.key_vault_sensitive.name
  resource_group_name = local.key_vault_sensitive.resource_group_name
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

# Managed Identity data sources (created in day-1)
data "azurerm_user_assigned_identity" "ingestion_cache_identity" {
  name                = local.ingestion_cache_identity_name
  resource_group_name = var.resource_group_sensitive_name
}

data "azurerm_user_assigned_identity" "ingestion_storage_identity" {
  name                = local.ingestion_storage_identity_name
  resource_group_name = var.resource_group_sensitive_name
}

# Log Analytics workspace data source (created in day-1)
data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = var.resource_group_core_name
}

# Grafana identity data source (created in day-1)
data "azurerm_user_assigned_identity" "grafana_identity" {
  name                = local.grafana_identity_name
  resource_group_name = var.resource_group_core_name
}

# Application Gateway data source
data "azurerm_application_gateway" "application_gateway" {
  name                = local.application_gateway_name
  resource_group_name = var.resource_group_core_name
}

# Azure Client Config for tenant_id
data "azurerm_client_config" "current" {}

# AKS Public IP data source (created in day-1)
data "azurerm_public_ip" "aks_public_ip" {
  name                = var.aks_public_ip_name
  resource_group_name = var.resource_group_core_name
}

# Virtual Network data source (created in day-1)
data "azurerm_virtual_network" "vnet" {
  name                = "vnet-001"
  resource_group_name = var.resource_group_name_vnet
}

# AKS Subnets data sources (created in day-1)
data "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name_vnet
}

data "azurerm_subnet" "aks_pods" {
  name                 = "snet-aks-pods"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name_vnet
}
