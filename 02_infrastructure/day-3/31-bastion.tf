# Azure Bastion Host
# Provides secure RDP/SSH access to VMs without exposing them to the internet

resource "azurerm_bastion_host" "this" {
  name                = local.bastion_name
  location            = var.resource_group_core_location
  resource_group_name = var.resource_group_core_name

  sku                       = var.bastion_sku
  tunneling_enabled         = var.bastion_sku != "Basic" ? var.bastion_tunneling_enabled : false # If bastion_sku is not defined it will fallbacke to "Basic" and then tunneling is not supported.
  file_copy_enabled  = var.bastion_sku != "Basic" # If bastion_sku is not defined it will fallbacke to "Basic" and then file copy is not supported.
  ip_connect_enabled = var.bastion_sku != "Basic" # If bastion_sku is not defined it will fallbacke to "Basic" and then IP connect is not supported.
  copy_paste_enabled        = true
  session_recording_enabled = false



  ip_configuration {
    name                 = "${local.bastion_name}-ipconfig"
    subnet_id            = data.azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = local.tags
}

