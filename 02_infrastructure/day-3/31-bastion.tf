# Azure Bastion Host
# Provides secure RDP/SSH access to VMs without exposing them to the internet

resource "azurerm_bastion_host" "this" {
  name                = local.bastion_name
  location            = var.resource_group_core_location
  resource_group_name = var.resource_group_core_name

  sku                       = var.bastion_sku
  tunneling_enabled         = var.bastion_tunneling_enabled
  file_copy_enabled         = true  # allows secure file transfer via Bastion (Standard/Premium only)
  ip_connect_enabled        = true  # connect to VMs by private IP, not just Azure resource - useful for non-Azure VMs in the VNET
  copy_paste_enabled        = true  # allows copy/paste from/to VMs
  session_recording_enabled = false # audit trail of Bastion sessions (Premium only)



  ip_configuration {
    name                 = "${local.bastion_name}-ipconfig"
    subnet_id            = data.azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = local.tags
}

