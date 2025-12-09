# Public IP for Azure Bastion
# Standard SKU is required for Standard Bastion SKU

resource "azurerm_public_ip" "bastion" {
  name                = local.bastion_public_ip_name
  sku                 = "Standard"
  location            = var.resource_group_core_location
  resource_group_name = var.resource_group_core_name
  allocation_method   = "Static"
  tags                = local.tags
}

