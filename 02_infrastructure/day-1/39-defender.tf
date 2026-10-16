# Azure Defender for Cloud

module "defender" {
  source          = "github.com/Unique-AG/terraform-modules.git//modules/azure-defender?ref=e073257d3ccbc123f42ba75fb6ce9668811d27ae" # azure-defender-3.0.1
  subscription_id = data.azurerm_subscription.current.id
  security_contact_settings = {
    email = var.defender_security_contact_email
  }

  storage_accounts_defender_settings = {
    extensions = var.defender_storage_accounts_extensions
  }
}
