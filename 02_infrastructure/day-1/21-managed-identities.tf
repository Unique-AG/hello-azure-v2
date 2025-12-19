# Managed Identities (User-Assigned)
# These identities are used by various services for authentication and authorization

resource "azurerm_user_assigned_identity" "psql_identity" {
  name                = local.psql_user_assigned_identity_name
  location            = azurerm_resource_group.sensitive.location
  resource_group_name = azurerm_resource_group.sensitive.name
}

resource "azurerm_user_assigned_identity" "ingestion_cache_identity" {
  name                = local.ingestion_cache_identity_name
  location            = azurerm_resource_group.sensitive.location
  resource_group_name = azurerm_resource_group.sensitive.name
}

resource "azurerm_user_assigned_identity" "ingestion_storage_identity" {
  name                = local.ingestion_storage_identity_name
  location            = azurerm_resource_group.sensitive.location
  resource_group_name = azurerm_resource_group.sensitive.name
}

resource "azurerm_user_assigned_identity" "document_intelligence_identity" {
  name                = local.document_intelligence_identity_name
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
}

resource "azurerm_user_assigned_identity" "aks_workload_identity" {
  name                = local.aks_user_assigned_identity_name
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
}

resource "azurerm_user_assigned_identity" "grafana_identity" {
  name                = local.grafana_identity_name
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
}