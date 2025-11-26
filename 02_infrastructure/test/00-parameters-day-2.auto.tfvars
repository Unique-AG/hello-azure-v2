# Day-2 specific parameters
# These reference resources created in day-1 by name and resource group
# Note: Day-2 also needs many of the same variables as day-1 for configuration

# Environment-specific configuration (shared with day-1)
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

# Tags
tags = {
  app = "hello-azure"
}

# Resource locations
resource_audit_location           = "swedencentral"
resource_group_core_location      = "swedencentral"
resource_group_sensitive_location = "swedencentral"
resource_vnet_location            = "swedencentral"

# User permissions
cluster_admin_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
  "0a28a069-6af6-43a3-9ef4-4b2a9c6d1b86"
]

keyvault_secret_writer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
]

telemetry_observer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
]

# DNS Configuration
custom_subdomain_name                       = "ha-test"
document_intelligence_custom_subdomain_name = "di-ha-test"
speech_service_private_dns_zone_name                      = "privatelink.cognitiveservices.azure.com"
speech_service_custom_subdomain_name                      = "ss-hello-azure-test"
speech_service_private_dns_zone_virtual_network_link_name = "vnet-link-speech-service"

# Resource Group Names (created in day-0)
resource_group_core_name      = "resource-group-core"
resource_group_sensitive_name = "resource-group-sensitive"
resource_group_name_vnet      = "rg-vnet-002"

# Key Vaults (created in day-0)
key_vault_core = {
  name                = "hakv1testv2"
  resource_group_name = "resource-group-core"
}

key_vault_sensitive = {
  name                = "hakv2testv2"
  resource_group_name = "resource-group-sensitive"
}

# AKS Cluster (created in day-0 or workloads)
aks = {
  name                = "aks-test"
  resource_group_name = "resource-group-core"
}

# DNS Zone (created in day-0)
dns_zone = {
  name                = "test-hello.azure.unique.dev"
  resource_group_name = "rg-vnet-002"
}

# Application Registration
application_registration_gitops_display_name = "GitOps"
application_secret_display_name              = "ha-test-gitops"

# User permissions
gitops_maintainer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
]

# Azure AD Groups
telemetry_observer_group_display_name        = "Telemetry Observer"
sensitive_data_observer_group_display_name   = "Sensitive Data Observer"
devops_group_display_name                    = "DevOps"
emergency_admin_group_display_name           = "Emergency Admin"
admin_kubernetes_cluster_group_display_name  = "Admin Kubernetes Cluster"
main_keyvault_secret_writer_group_display_name = "Main KeyVault writer"

# Federated Identity Credentials
cluster_workload_identities = {
  "backend-service-chat" = {
    name      = "backend-service-chat"
    namespace = "unique"
  }
  "backend-service-ingestion-worker-chat" = {
    name      = "backend-service-ingestion-worker-chat"
    namespace = "unique"
  }
  "backend-service-ingestion-worker" = {
    name      = "backend-service-ingestion-worker"
    namespace = "unique"
  }
  "backend-service-ingestion" = {
    name      = "backend-service-ingestion"
    namespace = "unique"
  }
  "assistants-core" = {
    name      = "assistants-core"
    namespace = "unique"
  }
  "backend-service-speech" = {
    name      = "backend-service-speech"
    namespace = "unique"
  }
}

