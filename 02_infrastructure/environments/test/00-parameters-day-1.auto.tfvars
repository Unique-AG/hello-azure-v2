# Environment-specific configuration
env = "test"

# Network configuration
subnet_agw_cidr = "10.202.3.0/28"

# Budget configuration
budget_contact_emails = ["support@unique.ch"]

# Key Vault configuration
kv_sku = "premium"

# GitOps configuration
gitops_display_name = "GitOps"

# DNS root A record (for day-1 DNS resources)
dns_zone_root_records = ["135.225.80.201"]

# DNS subdomain records
dns_subdomain_records = {
  api = {
    name    = "api"
    records = [] # Will be populated dynamically
  }
  argo = {
    name    = "argo"
    records = [] # Will be populated dynamically
  }
  zitadel = {
    name    = "id"
    records = [] # Will be populated dynamically
  }
}

# DNS zone subdomain records (for day-1 DNS resources)
# This maps to the for_each in azurerm_dns_a_record.adnsar_sub_domains
dns_zone_sub_domain_records = {
  api = {
    name    = "api"
    records = ["135.225.80.201"]
  }
  argo = {
    name    = "argo"
    records = ["135.225.80.201"]
  }
  zitadel = {
    name    = "id"
    records = ["135.225.80.201"]
  }
}

# Tags
tags = {
  app = "hello-azure"
}

# Resource locations
resource_audit_location           = "swedencentral"
resource_group_core_location      = "swedencentral"
resource_group_sensitive_location = "swedencentral"
resource_vnet_location            = "swedencentral"

# Resource Group IDs (will be set after resource groups are created)
resource_group_vnet_id = "" # Will be set to azurerm_resource_group.vnet.id after creation

# User permissions
cluster_admin_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
  "0a28a069-6af6-43a3-9ef4-4b2a9c6d1b86"
]
gitops_maintainer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
]
keyvault_secret_writer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
  "0a28a069-6af6-43a3-9ef4-4b2a9c6d1b86"
]
telemetry_observer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
]

# Speech Service configuration (private DNS zone name is not environment-specific)
speech_service_private_dns_zone_name = "privatelink.cognitiveservices.azure.com"

# Application Registration
application_registration_gitops_display_name = "GitOps"
