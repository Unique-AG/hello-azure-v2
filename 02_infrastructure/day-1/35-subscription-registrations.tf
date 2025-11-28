# Subscription Provider Registrations
# Register required Azure resource providers for the subscription

resource "azurerm_resource_provider_registration" "azure_dashboard_provider" {
  name = "Microsoft.Dashboard"
}

resource "azurerm_resource_provider_registration" "azure_monitor_provider" {
  name = "Microsoft.Monitor"
}

resource "azurerm_resource_provider_registration" "azure_alerts_provider" {
  name = "Microsoft.AlertsManagement"
}

