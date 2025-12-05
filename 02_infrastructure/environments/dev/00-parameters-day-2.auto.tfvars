# Day-2 specific parameters

# Resource Group Names
resource_group_core_name      = "resource-group-core"
resource_group_sensitive_name = "resource-group-sensitive"
resource_group_name_vnet      = "rg-vnet-002"

# Key Vaults
main_kv_name      = "helloazuremain"
sensitive_kv_name = "helloazuresensitive"

# AKS Cluster
cluster_name = "aks-dev"

# DNS Zone
dns_zone_name = "hello.azure.unique.dev"

# Application Registration
application_registration_gitops_display_name = "GitOps"
application_secret_display_name              = "hello-azure-dev-gitops"

# User permissions
gitops_maintainer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
  "45caeab6-e1dd-4f9a-aa0c-ea1fb6c0c5ff",
]

# Azure AD Groups
telemetry_observer_group_display_name          = "Telemetry Observer"
sensitive_data_observer_group_display_name     = "Sensitive Data Observer"
devops_group_display_name                      = "DevOps"
emergency_admin_group_display_name             = "Emergency Admin"
admin_kubernetes_cluster_group_display_name    = "Admin Kubernetes Cluster"
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

# OpenAI Cognitive Accounts
openai_cognitive_accounts = {
  "cognitive-account-swedencentral" = {
    name                          = "cognitive-account-swedencentral"
    location                      = "swedencentral"
    local_auth_enabled            = false
    custom_subdomain_name         = "hello-azure-unique"
    public_network_access_enabled = true
    cognitive_deployments = [
      {
        name          = "text-embedding-ada-002"
        model_name    = "text-embedding-ada-002"
        model_version = "2"
        sku_name      = null
        sku_capacity  = 350
      },
      {
        name          = "gpt-35-turbo-0125"
        model_name    = "gpt-35-turbo"
        model_version = "0125"
        sku_name      = null
        sku_capacity  = 120
      },
      {
        name          = "gpt-4o-2024-11-20"
        model_name    = "gpt-4o"
        model_version = "2024-11-20"
        sku_name      = "Standard"
        sku_capacity  = 50
      }
    ]
  }
}

# OpenAI Document Intelligence Accounts
document_intelligence_accounts = {
  "swedencentral-form-recognizer" = {
    location                      = "swedencentral"
    custom_subdomain_name         = "di-hello-azure-unique"
    public_network_access_enabled = true
    local_auth_enabled            = false
  }
}

# OpenAI Speech Service
speech_service_name = "speech-service"
speech_service_accounts = {
  "swedencentral-speech" = {
    location              = "swedencentral"
    account_kind          = "SpeechServices"
    account_sku_name      = "S0"
    custom_subdomain_name = "ss-hello-azure-unique"
    private_endpoint = {
      subnet_id           = "snet-cognitive-services"
      vnet_id             = "vnet-001"
      vnet_location       = "swedencentral"
      private_dns_zone_id = "private-dns-zone-speech-service"
    }
  }
}
