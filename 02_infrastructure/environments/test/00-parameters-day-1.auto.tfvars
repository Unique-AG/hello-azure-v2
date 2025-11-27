# Environment-specific configuration
dns_zone_name                       = "test-hello.azure.unique.dev"
name_prefix                         = "ha-test"
subnet_agw_cidr                     = "10.202.3.0/28"
budget_contact_emails               = ["support@unique.ch"]
kv_sku                              = "premium"
log_analytics_workspace_name        = "la-test"
aks_user_assigned_identity_name     = "aks-id-test"
cluster_name                        = "aks-test"
gitops_display_name                 = "GitOps"
document_intelligence_identity_name = "docint-id-test"
ingestion_cache_identity_name       = "cache-id-test"
ingestion_storage_identity_name     = "storage-id-test"
psql_user_assigned_identity_name   = "psql-id-test"
csi_identity_name                   = "csi-id-test"
grafana_identity_name               = "grafana-id-test"
main_kv_name                        = "hakv1testv2"
sensitive_kv_name                   = "hakv2testv2"
environment                         = "test"
container_registry_name             = "uqhacrtest"
redis_name                          = "uqharedis-test"
ingestion_cache_sa_name             = "uqhacachetest"
ingestion_storage_sa_name           = "uqhastoragetest"

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
# Required for import - Terraform needs to know about these instances before importing
# Records are from terraform.tfstate: all subdomains point to 135.225.80.201
# Note: Using list syntax - Terraform will auto-convert to set(string) as required by the variable type
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
resource_group_vnet_id = ""  # Will be set to azurerm_resource_group.vnet.id after creation

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

custom_subdomain_name                       = "ha-test"
document_intelligence_custom_subdomain_name = "di-ha-test"

speech_service_private_dns_zone_virtual_network_link_name = "speech-service-private-dns-zone-vnet-link-test"
speech_service_private_dns_zone_name                      = "privatelink.cognitiveservices.azure.com"
speech_service_custom_subdomain_name                      = "ss-hello-azure-test"

# Application Registration
application_registration_gitops_display_name = "GitOps"
application_secret_display_name              = "ha-test-gitops"

# Key Vault IDs (will be set after key vaults are created/imported)
# For now, using the known ID from the existing infrastructure
sensitive_kv_id = "/subscriptions/782871a0-bcee-44fb-851f-ccd3e69ada2a/resourceGroups/resource-group-sensitive/providers/Microsoft.KeyVault/vaults/hakv2testv2"