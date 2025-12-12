# Azure OpenAI Service
# This module creates and configures Azure OpenAI cognitive accounts with deployments
module "openai" {
  source = "github.com/unique-ag/terraform-modules.git//modules/azure-openai?depth=1&ref=azure-openai-2.4.0"

  resource_group_name         = data.azurerm_resource_group.core.name
  endpoint_secret_name_suffix = var.openai_endpoint_secret_name_suffix
  # WORKAROUND: Set to null to bypass module bug in secrets.tf for_each
  key_vault_id = null

  cognitive_accounts = {
    for k, v in var.openai_cognitive_accounts : k => {
      name                          = "${v.name}"
      location                      = v.location
      local_auth_enabled            = v.local_auth_enabled
      custom_subdomain_name         = local.custom_subdomain_name
      public_network_access_enabled = v.public_network_access_enabled
      cognitive_deployments         = v.cognitive_deployments
    }
  }

  tags = var.tags
}

# Azure Document Intelligence Service
# This module creates and configures Azure Document Intelligence (Form Recognizer) accounts
# 
# WORKAROUND: The module has a bug in secrets.tf line 4-7 where it uses azurerm_cognitive_account.aca 
# directly in for_each, causing "known only after apply" errors. To work around this, we set 
# key_vault_id = null which disables the problematic secrets creation (local.create_vault_secrets = false),
# allowing the module to work for importing and managing the main resources.
# 
# Key Vault secrets drift: The secrets exist in Azure but are not managed by Terraform due to this 
# workaround. They can be managed manually or wait for a module fix.
module "document_intelligence" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-document-intelligence?ref=azure-document-intelligence-3.0.3"

  doc_intelligence_name = local.document_intelligence_name
  resource_group_name   = data.azurerm_resource_group.core.name
  # WORKAROUND: Set to null to bypass module bug in secrets.tf for_each
  key_vault_id = null

  accounts = {
    for k, v in var.document_intelligence_accounts : k => {
      location                      = v.location
      custom_subdomain_name         = local.document_intelligence_custom_subdomain_name
      public_network_access_enabled = v.public_network_access_enabled
      local_auth_enabled            = v.local_auth_enabled
    }
  }

  tags = var.tags
}

# Azure Speech Service
# This module creates and configures Azure Speech Service accounts with optional private endpoints
# Note: This module uses count instead of for_each for secrets, so it doesn't have the same bug
module "speech_service" {
  source = "github.com/unique-ag/terraform-modules.git//modules/azure-speech-service?depth=1&ref=azure-speech-service-4.0.1"

  key_vault_id        = data.azurerm_key_vault.key_vault_sensitive.id
  resource_group_name = data.azurerm_resource_group.core.name
  # Use var.speech_service_name directly (without env suffix) to match existing resource names
  # The existing private endpoint is named "speech-service-swedencentral-speech-pe" (no env suffix)
  speech_service_name = var.speech_service_name

  accounts = {
    for k, v in var.speech_service_accounts : k => {
      location              = v.location
      account_kind          = v.account_kind
      account_sku_name      = v.account_sku_name
      custom_subdomain_name = v.custom_subdomain_name

      # Configure private endpoint if provided
      private_endpoint = v.private_endpoint == true ? {
        subnet_id           = data.azurerm_subnet.subnet_cognitive_services_day_1.id
        vnet_id             = data.azurerm_virtual_network.vnet_day_1.id
        vnet_location       = data.azurerm_virtual_network.vnet_day_1.location
        private_dns_zone_id = data.azurerm_private_dns_zone.speech_service_day_1.id
      } : null

      # Configure diagnostic settings if provided
      # Can be changed to data block for log_analytics_workspace_id
      diagnostic_settings = v.diagnostic_settings != null ? {
        log_analytics_workspace_id = v.diagnostic_settings.log_analytics_workspace_id
        enabled_log_categories     = v.diagnostic_settings.enabled_log_categories
      } : null
    }
  }

}
