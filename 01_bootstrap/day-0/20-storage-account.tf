module "tfstate_sa" {
  source              = "github.com/unique-ag/terraform-modules.git//modules/azure-storage-account?depth=1&ref=azure-storage-account-3.1.0"
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.tfstate_location
  backup_vault        = null
  containers = {
    (var.container_name) = {}
  }
  public_network_access_enabled = true
}
