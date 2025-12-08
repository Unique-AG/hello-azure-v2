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

# PostgreSQL data sources (created in day-1)
data "azurerm_subnet" "postgresql" {
  name                 = var.postgresql_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.vnet.name
}

data "azurerm_private_dns_zone" "postgresql" {
  name                = var.psql_private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.vnet.name
}

data "azurerm_user_assigned_identity" "psql_identity" {
  name                = local.psql_user_assigned_identity_name
  resource_group_name = var.resource_group_sensitive_name
}
