module "tfstate_sa" {
  source              = "github.com/unique-ag/terraform-modules.git//modules/azure-storage-account?depth=1&ref=e13f80c3b93e9e5a4e91d3d8dd7322358b52a49c" # azure-storage-account-3.1.0
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = var.tfstate_location
  backup_vault        = null
  containers = {
    (var.container_name) = {}
  }
  public_network_access_enabled = true
}
