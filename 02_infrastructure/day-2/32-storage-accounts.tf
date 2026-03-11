module "ingestion_cache" {
  source = "github.com/unique-ag/terraform-modules.git//modules/azure-storage-account?depth=1&ref=azure-storage-account-3.1.0"

  name                          = local.ingestion_cache_sa_name
  resource_group_name           = data.azurerm_resource_group.sensitive.name
  location                      = data.azurerm_resource_group.sensitive.location
  tags                          = var.tags
  access_tier                   = var.ingestion_cache_access_tier
  account_replication_type      = var.ingestion_cache_account_replication_type
  backup_vault                  = var.ingestion_cache_backup_vault
  public_network_access_enabled = var.ingestion_cache_public_network_access_enabled

  data_protection_settings = var.ingestion_cache_data_protection_settings

  storage_management_policy_default = var.ingestion_cache_storage_management_policy_default

  self_cmk = {
    key_vault_id              = data.azurerm_key_vault.key_vault_sensitive.id
    key_name                  = var.ingestion_cache_self_cmk_key_name
    user_assigned_identity_id = data.azurerm_user_assigned_identity.ingestion_cache_identity.id
  }

  connection_settings = {
    connection_string_1 = var.ingestion_cache_connection_string_1_secret_name
    connection_string_2 = var.ingestion_cache_connection_string_2_secret_name
    key_vault_id        = data.azurerm_key_vault.key_vault_sensitive.id
  }

  identity_ids = [data.azurerm_user_assigned_identity.ingestion_cache_identity.id]
}

module "ingestion_storage" {
  source = "github.com/unique-ag/terraform-modules.git//modules/azure-storage-account?depth=1&ref=azure-storage-account-3.1.0"

  name                          = local.ingestion_storage_sa_name
  resource_group_name           = data.azurerm_resource_group.sensitive.name
  location                      = data.azurerm_resource_group.sensitive.location
  tags                          = var.tags
  access_tier                   = var.ingestion_storage_access_tier
  account_replication_type      = var.ingestion_storage_account_replication_type
  backup_vault                  = var.ingestion_storage_backup_vault
  public_network_access_enabled = var.ingestion_storage_public_network_access_enabled

  data_protection_settings = {
    change_feed_enabled                  = var.ingestion_storage_data_protection_settings.change_feed_enabled
    change_feed_retention_days           = var.ingestion_storage_data_protection_settings.change_feed_retention_days
    versioning_enabled                   = var.ingestion_storage_data_protection_settings.versioning_enabled
    container_soft_delete_retention_days = var.ingestion_storage_data_protection_settings.container_soft_delete_retention_days
    blob_soft_delete_retention_days      = var.ingestion_storage_data_protection_settings.blob_soft_delete_retention_days
    point_in_time_restore_days           = var.ingestion_storage_data_protection_settings.point_in_time_restore_days
  }

  storage_management_policy_default = {
    enabled                                  = var.ingestion_storage_storage_management_policy_default.enabled
    blob_to_cool_after_last_modified_days    = var.ingestion_storage_storage_management_policy_default.blob_to_cool_after_last_modified_days
    blob_to_cold_after_last_modified_days    = var.ingestion_storage_storage_management_policy_default.blob_to_cold_after_last_modified_days
    blob_to_archive_after_last_modified_days = var.ingestion_storage_storage_management_policy_default.blob_to_archive_after_last_modified_days
    blob_to_deleted_after_last_modified_days = var.ingestion_storage_storage_management_policy_default.blob_to_deleted_after_last_modified_days
  }

  self_cmk = {
    key_vault_id              = data.azurerm_key_vault.key_vault_sensitive.id
    key_name                  = var.ingestion_storage_self_cmk_key_name
    user_assigned_identity_id = data.azurerm_user_assigned_identity.ingestion_storage_identity.id
  }

  connection_settings = {
    connection_string_1 = var.ingestion_storage_connection_string_1_secret_name
    connection_string_2 = var.ingestion_storage_connection_string_2_secret_name
    key_vault_id        = data.azurerm_key_vault.key_vault_sensitive.id
  }

  identity_ids = [data.azurerm_user_assigned_identity.ingestion_storage_identity.id]
}

