#tfsec:ignore:azure-keyvault-content-type-for-secret
#tfsec:ignore:azure-keyvault-ensure-key-expiry
module "audit_storage" {
  source = "github.com/unique-ag/terraform-modules.git//modules/azure-storage-account?depth=1&ref=ef9f33b0e00c301f1e40ffeb47988a1569757ee5" # azure-storage-account-4.0.0

  name                          = var.audit_storage_sa_name
  resource_group_name           = data.azurerm_resource_group.sensitive.name
  location                      = data.azurerm_resource_group.sensitive.location
  tags                          = var.tags
  access_tier                   = "Hot"
  account_replication_type      = "LRS"
  backup_vault                  = null # backup vaults don't support NFS/HNS
  public_network_access_enabled = true

  is_nfs_mountable = true # so it can be attached to pods

  containers = {
    for container in var.audit_containers : container => {
      access_type = "private"
    }
  }

  network_rules = {
    ip_rules = ["0.0.0.0/0"]
    virtual_network_subnet_ids = [
      data.azurerm_subnet.aks_nodes.id,
      data.azurerm_subnet.aks_pods.id
    ]
    private_link_accesses = [{
      endpoint_resource_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Security/datascanners/storageDataScanner"
      endpoint_tenant_id   = var.tenant_id
    }]
  }

  data_protection_settings = {
    change_feed_retention_days = -1    # cant be active when versioning is disabled
    point_in_time_restore_days = -1    # cant be active when versioning is disabled
    versioning_enabled         = false # NFS cant use versioning
  }

  storage_management_policy_default = {
    enabled                                  = true
    blob_to_cool_after_last_modified_days    = 30
    blob_to_cold_after_last_modified_days    = 90
    blob_to_archive_after_last_modified_days = 180
    blob_to_deleted_after_last_modified_days = 7 * 365
  }

  self_cmk = {
    key_vault_id              = data.azurerm_key_vault.key_vault_sensitive.id
    key_name                  = "audit-storage-cmk"
    user_assigned_identity_id = data.azurerm_user_assigned_identity.audit_storage_identity.id
  }

  identity_ids = [data.azurerm_user_assigned_identity.audit_storage_identity.id]
}
