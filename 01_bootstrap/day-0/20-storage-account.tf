module "tfstate_sa" {
  source              = "github.com/unique-ag/terraform-modules.git//modules/azure-storage-account?ref=32d9495aaac9134231925f1dc682d84fb1adf6b8"
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
