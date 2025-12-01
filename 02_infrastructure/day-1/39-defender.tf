# Azure Defender for Cloud
# Security monitoring and threat protection for the subscription

module "defender" {
  source          = "github.com/unique-ag/terraform-modules.git//modules/azure-defender?depth=1&ref=azure-defender-2.2.0"
  subscription_id = data.azurerm_subscription.current.id

  security_contact_settings          = local.defender_settings.security_contact_settings
  storage_accounts_defender_settings = local.defender_settings.storage_accounts_defender_settings
}

