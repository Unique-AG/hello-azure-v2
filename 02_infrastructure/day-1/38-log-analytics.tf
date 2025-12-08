# Log Analytics Workspace
# Centralized logging and monitoring workspace

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_workspace_name
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_in_days
}

