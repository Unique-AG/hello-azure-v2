# Azure Defender for Cloud
# Security monitoring and threat protection for the subscription

module "defender" {
  source          = "github.com/unique-ag/terraform-modules.git//modules/azure-defender?depth=1&ref=azure-defender-2.2.0"
  subscription_id = data.azurerm_subscription.current.id
  security_contact_settings = {
    email = "security-events@unique.ch"
  }

  # Explicitly set storage_accounts_defender_settings to match Azure state
  storage_accounts_defender_settings = {
    extensions = [
      {
        name = "OnUploadMalwareScanning"
        additional_extension_properties = {
          AutomatedResponse              = "None"
          BlobScanResultsOptions         = "BlobIndexTags"
          CapGBPerMonthPerStorageAccount = "1000"
        }
      },
      {
        name = "SensitiveDataDiscovery"
      }
    ]
  }
}

