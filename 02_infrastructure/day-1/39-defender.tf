# Azure Defender for Cloud

module "defender" {
  source          = "github.com/unique-ag/terraform-modules.git//modules/azure-defender?depth=1&ref=5ef684ee2f2d915bf2b543309995636dc8ee5ca9" # azure-defender-2.2.0
  subscription_id = data.azurerm_subscription.current.id
  security_contact_settings = {
    email = var.defender_security_contact_email
  }

  storage_accounts_defender_settings = {
    extensions = var.defender_storage_accounts_extensions
  }
}
