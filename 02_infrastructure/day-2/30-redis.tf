# Azure Redis Cache
# Using the azure-redis module from terraform-modules

module "redis" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-redis?ref=azure-redis-2.0.0"

  name                = local.redis_name
  resource_group_name = data.azurerm_resource_group.sensitive.name
  location            = data.azurerm_resource_group.sensitive.location

  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags
  key_vault_id                  = data.azurerm_key_vault.key_vault_sensitive.id
}

