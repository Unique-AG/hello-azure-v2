resource "azurerm_resource_group" "tfstate" {
  name     = local.resource_group_name
  location = var.tfstate_location
}
