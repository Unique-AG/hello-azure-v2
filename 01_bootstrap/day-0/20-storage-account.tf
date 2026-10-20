module "tfstate_sa" {
  source              = "github.com/Unique-AG/terraform-modules.git//modules/azure-storage-account?ref=55099de28a949afc0ba8dd66a9b716364feac4ba" # azure-storage-account-7.1.1
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
