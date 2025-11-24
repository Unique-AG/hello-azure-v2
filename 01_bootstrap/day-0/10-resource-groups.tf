resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.tfstate_location
}
