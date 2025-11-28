# Key Vaults
# These Key Vaults are used for storing secrets and keys for the infrastructure

resource "azurerm_key_vault" "sensitive_kv" {
  name                        = local.sensitive_kv_name
  location                    = azurerm_resource_group.sensitive.location
  resource_group_name         = azurerm_resource_group.sensitive.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = var.kv_sku
  tags                        = var.tags
  rbac_authorization_enabled  = true
  #FIXME: With private GitHub runners, we could allow only traffic from specific IP ranges here instead
  #tfsec:ignore:azure-keyvault-specify-network-acl
  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}

resource "azurerm_key_vault" "main_kv" {
  name                        = local.main_kv_name
  location                    = azurerm_resource_group.core.location
  resource_group_name         = azurerm_resource_group.core.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = var.kv_sku
  tags                        = var.tags
  rbac_authorization_enabled  = true
  #FIXME: With private GitHub runners, we could allow only traffic from specific IP ranges here instead
  #tfsec:ignore:azure-keyvault-specify-network-acl
  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}

