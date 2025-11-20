# Resource Groups
# These are the foundation resources that other resources depend on

resource "azurerm_resource_group" "vnet" {
  name     = "rg-vnet-002"
  location = var.resource_vnet_location
}

# Note: Resource group names need to match the actual names used in hello-azure/infrastructure/test
# These will be verified during state import to ensure zero drift
resource "azurerm_resource_group" "core" {
  name     = var.resource_group_core_name
  location = var.resource_group_core_location
}

resource "azurerm_resource_group" "sensitive" {
  name     = var.resource_group_sensitive_name
  location = var.resource_group_sensitive_location
}

