# Subscription Provider Registrations

resource "azurerm_resource_provider_registration" "azure_dashboard_provider" {
  name = local.azure_resource_provider_registrations.azure_dashboard_provider.name
}

resource "azurerm_resource_provider_registration" "azure_monitor_provider" {
  name = local.azure_resource_provider_registrations.azure_monitor_provider.name
}

resource "azurerm_resource_provider_registration" "azure_alerts_provider" {
  name = local.azure_resource_provider_registrations.azure_alerts_provider.name
}

