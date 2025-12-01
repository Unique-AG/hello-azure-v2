# Log Analytics Workspace
# Centralized logging and monitoring workspace

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_workspace_name
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  sku                 = local.log_analytics.sku
  retention_in_days   = local.log_analytics.retention_in_days
}

