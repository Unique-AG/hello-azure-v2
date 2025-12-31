# Container Registry
# Azure Container Registry (ACR) for container images

resource "azurerm_container_registry" "acr" {
  name                = local.container_registry_name
  location            = data.azurerm_resource_group.core.location
  resource_group_name = data.azurerm_resource_group.core.name
  sku                 = var.container_registry_sku
  admin_enabled       = var.container_registry_admin_enabled
  identity {
    type = var.container_registry_identity_type
  }
  tags = var.tags
}