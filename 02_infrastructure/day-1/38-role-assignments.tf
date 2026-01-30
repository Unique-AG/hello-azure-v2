# CMK Role Assignments for Managed Identities
# These role assignments are created in day-1 to ensure RBAC propagation completes
# before day-2 attempts to use the permissions for Customer Managed Keys (CMK)
#
# NOTE: User role assignments are defined in 36-key-vaults.tf
# NOTE: data.azuread_user.keyvault_secret_writer is defined in 03-data.tf

# ============================================================================
# Managed Identity Role Assignments - CMK Access
# ============================================================================

# Ingestion Cache Identity - CMK access to Sensitive Key Vault
resource "azurerm_role_assignment" "ingestion_cache_kv_crypto" {
  principal_id         = azurerm_user_assigned_identity.ingestion_cache_identity.principal_id
  scope                = azurerm_key_vault.sensitive_kv.id
  role_definition_name = var.key_vault_crypto_service_encryption_user_role_name
}

resource "azurerm_role_assignment" "ingestion_cache_kv_secrets_reader" {
  principal_id         = azurerm_user_assigned_identity.ingestion_cache_identity.principal_id
  scope                = azurerm_key_vault.sensitive_kv.id
  role_definition_name = var.secret_reader_key_vault_role_name
}

# Ingestion Storage Identity - CMK access to Sensitive Key Vault
resource "azurerm_role_assignment" "ingestion_storage_kv_crypto" {
  principal_id         = azurerm_user_assigned_identity.ingestion_storage_identity.principal_id
  scope                = azurerm_key_vault.sensitive_kv.id
  role_definition_name = var.key_vault_crypto_service_encryption_user_role_name
}

resource "azurerm_role_assignment" "ingestion_storage_kv_secrets_reader" {
  principal_id         = azurerm_user_assigned_identity.ingestion_storage_identity.principal_id
  scope                = azurerm_key_vault.sensitive_kv.id
  role_definition_name = var.secret_reader_key_vault_role_name
}

# Audit Storage Identity - CMK access to Sensitive Key Vault
resource "azurerm_role_assignment" "audit_storage_kv_crypto" {
  principal_id         = azurerm_user_assigned_identity.audit_storage_identity.principal_id
  scope                = azurerm_key_vault.sensitive_kv.id
  role_definition_name = var.key_vault_crypto_service_encryption_user_role_name
}

resource "azurerm_role_assignment" "audit_storage_kv_secrets_reader" {
  principal_id         = azurerm_user_assigned_identity.audit_storage_identity.principal_id
  scope                = azurerm_key_vault.sensitive_kv.id
  role_definition_name = var.secret_reader_key_vault_role_name
}
