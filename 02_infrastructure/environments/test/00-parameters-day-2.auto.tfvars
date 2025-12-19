# Day-2 specific parameters
env = "test"

# Network configuration
subnet_agw_cidr = "10.202.3.0/28"

# Application Gateway configuration
# Use explicit name to preserve existing gateway IP configuration name and avoid replacement
# Existing name is "ha-test-gwip", but default would be "gateway-ip-configuration"
application_gateway_gateway_ip_configuration_name = "ha-test-gwip"

# Budget configuration
budget_contact_emails = ["support@unique.ch"]

# Key Vault configuration
kv_sku = "premium"

# Terraform Service Principal (created in day-0/bootstrap)
# To get the object_id, run: az ad sp list --display-name "terraform" --query "[].{objectId:id,displayName:displayName}" -o table, or go to Azure Portal -> Enterprise Applications -> Terraform -> Object ID
terraform_service_principal_object_id = "dde525a7-fbfa-4a7c-88da-b9bcaf75830f" # 

# GitOps configuration
gitops_display_name = "GitOps"

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

# Speech Service configuration (private DNS zone name is not environment-specific)
speech_service_private_dns_zone_name = "privatelink.cognitiveservices.azure.com"

# Resource Group Names (created in day-0)
resource_group_core_name      = "resource-group-core"
resource_group_sensitive_name = "resource-group-sensitive"
resource_group_name_vnet      = "rg-vnet-002"

# Key Vaults, AKS, and DNS Zone objects are computed in locals from var.env
main_kv_name      = "hakv1"
sensitive_kv_name = "hakv2"

# DNS Zone
dns_zone_name = "test-hello.azure.unique.dev"

# Application Registration
application_registration_gitops_display_name = "GitOps"

# User permissions
gitops_maintainer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
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
    local_auth_enabled            = true
  }
}

# OpenAI Speech Service
speech_service_name = "speech-service"
speech_service_accounts = {
  "swedencentral-speech" = {
    location              = "swedencentral"
    account_kind          = "SpeechServices"
    account_sku_name      = "S0"
    custom_subdomain_name = "ss-hello-azure-test"
    private_endpoint      = true
  }
}

# Secrets
rabbitmq_password_chat_secret_name        = "rabbitmq-password-chat"
zitadel_db_user_password_secret_name      = "zitadel-db-user-password"
zitadel_master_key_secret_name            = "zitadel-master-key"
encryption_key_app_repository_secret_name = "encryption-key-app-repository"
encryption_key_node_chat_lxm_secret_name  = "encryption-key-chat-lxm"
encryption_key_ingestion_secret_name      = "encryption-key-ingestion"
zitadel_pat_secret_name                   = "manual-zitadel-scope-mgmt-pat"

# Secret Generation Configuration
secret_password_length        = 32
rabbitmq_password_chat_length = 24
secret_expiration_date        = "2099-12-31T23:59:59Z"

# Kubernetes Configuration
kubernetes_node_pool_settings = {
  rapid = {
    max_count   = 3
    min_count   = 0
    node_count  = 0
    node_taints = ["scalability=rapid:NoSchedule", "lifecycle=ephemeral:NoSchedule"]
    node_labels = {
      lifecycle   = "ephemeral"
      scalability = "rapid"
    }
    vm_size = "Standard_D8s_v4"
  },
  steady = {
    max_count   = 4
    min_count   = 0
    node_count  = 2
    node_taints = []
    node_labels = {
      lifecycle   = "persistent"
      scalability = "steady"
    }
    upgrade_settings = {
      max_surge = "30%"
    }
    vm_size = "Standard_D8as_v5"
  }
}
