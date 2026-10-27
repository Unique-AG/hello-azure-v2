module "tfstate_sa" {
  source              = "github.com/Unique-AG/terraform-modules.git//modules/azure-storage-account?ref=9486e9f06c83a8a2b7edd4ba64c3522a6d2a697b" # azure-storage-account-8.0.1
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = var.tfstate_location
  backup_vault        = null
  containers = {
    (var.container_name) = {}
  }
  public_network_access_enabled = true
  shared_access_key_enabled     = true
}
