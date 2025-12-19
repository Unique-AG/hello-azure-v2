# Key Vaults

resource "azurerm_key_vault" "sensitive_kv" {
  name                        = local.key_vault_sensitive.name
  location                    = azurerm_resource_group.sensitive.location
  resource_group_name         = azurerm_resource_group.sensitive.name
  enabled_for_disk_encryption = local.key_vault_sensitive.enabled_for_disk_encryption
  tenant_id                   = local.key_vault_sensitive.tenant_id
  soft_delete_retention_days  = local.key_vault_sensitive.soft_delete_retention_days
  purge_protection_enabled    = local.key_vault_sensitive.purge_protection_enabled
  sku_name                    = local.key_vault_sensitive.sku_name
  tags                        = local.key_vault_sensitive.tags
  rbac_authorization_enabled  = local.key_vault_sensitive.rbac_authorization_enabled
  #FIXME: With private GitHub runners, we could allow only traffic from specific IP ranges here instead
  #tfsec:ignore:azure-keyvault-specify-network-acl

  dynamic "network_acls" {
    for_each = local.key_vault_sensitive.network_acls != null ? [local.key_vault_sensitive.network_acls] : []
    content {
      bypass         = network_acls.value.bypass
      default_action = network_acls.value.default_action
    }
  }

}

resource "azurerm_key_vault" "main_kv" {
  name                        = local.key_vault_core.name
  location                    = azurerm_resource_group.core.location
  resource_group_name         = azurerm_resource_group.core.name
  enabled_for_disk_encryption = local.key_vault_core.enabled_for_disk_encryption
  tenant_id                   = local.key_vault_core.tenant_id
  soft_delete_retention_days  = local.key_vault_core.soft_delete_retention_days
  purge_protection_enabled    = local.key_vault_core.purge_protection_enabled
  sku_name                    = local.key_vault_core.sku_name
  tags                        = local.key_vault_core.tags
  rbac_authorization_enabled  = local.key_vault_core.rbac_authorization_enabled
  #FIXME: With private GitHub runners, we could allow only traffic from specific IP ranges here instead
  #tfsec:ignore:azure-keyvault-specify-network-acl

  dynamic "network_acls" {
    for_each = local.key_vault_core.network_acls != null ? [local.key_vault_core.network_acls] : []
    content {
      bypass         = network_acls.value.bypass
      default_action = network_acls.value.default_action
    }
  }
}

