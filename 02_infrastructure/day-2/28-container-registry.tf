# Container Registry
# Azure Container Registry (ACR) for container images

resource "azurerm_container_registry" "acr" {
  name                = local.container_registry_name
  location            = data.azurerm_resource_group.core.location
  resource_group_name = data.azurerm_resource_group.core.name
  sku                 = "Basic"
  admin_enabled       = false
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

# NOTE: Diagnostic settings for Container Registry cannot be imported via Terraform
# even though they exist in Azure. This is a known limitation of the Azure provider.
# The diagnostic setting "log-helloazure" exists in Azure but Terraform cannot import it.
# TODO: Uncomment once this limitation is resolved, or let Terraform create it fresh
# resource "azurerm_monitor_diagnostic_setting" "acr_diagnostic" {
#   name                       = var.registry_diagnostic_name
#   target_resource_id         = azurerm_container_registry.acr.id
#   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
#
#   enabled_log {
#     category_group = "allLogs"
#   }
# }

