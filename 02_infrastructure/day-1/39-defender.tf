# Azure Defender for Cloud

module "defender" {
  source          = "github.com/unique-ag/terraform-modules.git//modules/azure-defender?ref=f1aa377b4602d9fe3599c96dbfbc02634e900930"
  subscription_id = data.azurerm_subscription.current.id
  security_contact_settings = {
    email = var.defender_security_contact_email
  }

  storage_accounts_defender_settings = {
    extensions = var.defender_storage_accounts_extensions
  }
}
