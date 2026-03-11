# Public IPs
# AKS public IP for outbound connectivity

resource "azurerm_public_ip" "aks_public_ip" {
  name                = var.aks_public_ip_name
  sku                 = "Standard"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  allocation_method   = "Static"
}

