# Backend Configuration Variables
variable "subscription_id" {
  description = "The UUID ID of the suscription"
  type        = string
}

variable "tenant_id" {
  description = "The ID of the tenenat"
  type        = string
}

variable "client_id" {
  description = "The client ID for OIDC"
  type        = string
}

variable "use_oidc" {
  description = "Whether to use OIDC"
  type        = bool
}

variable "resource_group_name" {
  description = "The resource group name for the tfstate."
  type        = string
}
variable "storage_account_name" {
  description = "The resource group name for the storage account name"
  type        = string
}
variable "container_name" {
  description = "The resource group name for the tfstate container name"
  type        = string
}
variable "key" {
  description = "The key for the tfstate"
  type        = string
}

# Resource Locations
variable "resource_audit_location" {
  description = "The location for resource audit resources"
  type        = string
}

variable "resource_group_core_location" {
  description = "The location for core resource group"
  type        = string
}

variable "resource_group_sensitive_location" {
  description = "The location for sensitive resource group"
  type        = string
}

variable "resource_vnet_location" {
  description = "The location for virtual network resources"
  type        = string
}

# Resource Group Names
variable "resource_group_core_name" {
  description = "The core resource group name"
  type        = string
}

variable "resource_group_sensitive_name" {
  description = "The sensitive resource group name"
  type        = string
}

variable "resource_group_name_vnet" {
  description = "Name of the resource group containing the VNET"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network (created in day-1)"
  type        = string
  default     = "vnet-001"
}

variable "postgresql_subnet_name" {
  description = "Name of the PostgreSQL subnet (created in day-1)"
  type        = string
  default     = "snet-postgres"
}

# Naming and Tagging
variable "name_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "ha"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# Network Configuration
variable "subnet_agw_cidr" {
  description = "CIDR block for the Application Gateway subnet"
  type        = string
}

# DNS Configuration
variable "dns_zone_name" {
  description = "The DNS zone name for the environment"
  type        = string
  default     = "hello.azure.unique.dev"
}

variable "custom_subdomain_name" {
  description = "The custom subdomain name to use for the application"
  type        = string
  default     = "ha"
}

variable "application_gateway_name" {
  description = "Application Gateway name."
  type        = string
  default     = "appgw"
}

variable "document_intelligence_custom_subdomain_name" {
  description = "The custom subdomain name to use for the document intelligence"
  type        = string
  default     = "di-ha"
}

variable "dns_subdomain_records" {
  description = "Map of DNS subdomain records"
  type = map(object({
    name    = string
    records = list(string)
  }))
}

# Key Vault Configuration
variable "main_kv_name" {
  description = "Name of the main Key Vault"
  type        = string
  default     = "hakv1"
}

variable "sensitive_kv_name" {
  description = "Name of the sensitive key vault"
  type        = string
  default     = "hakv2"
}

# Monitoring and Analytics
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "la"
}

variable "budget_contact_emails" {
  description = "List of email addresses for budget notifications"
  type        = list(string)
}

# Application Gateway Configuration
variable "ip_name" {
  description = "Name of the public IP for the Application Gateway"
  type        = string
  default     = "default-public-ip-name"
}

# Key Vault SKU (for compatibility with day-1, not used in day-2 but may be in tfvars)
variable "kv_sku" {
  description = "SKU for Key Vault (for compatibility, not used in day-2)"
  type        = string
  default     = "premium"
}

# Terraform Service Principal
variable "terraform_service_principal_object_id" {
  description = "Object ID of the Terraform service principal (created in day-0/bootstrap)."
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks"
}

# Managed Identities
variable "aks_user_assigned_identity_name" {
  description = "The name of the AKS user-assigned identity"
  type        = string
  default     = "aks-id"
}

variable "document_intelligence_identity_name" {
  description = "The name of the document intelligence identity"
  type        = string
  default     = "docint-id"
}

variable "ingestion_cache_identity_name" {
  description = "The name of the ingestion cache identity"
  type        = string
  default     = "cache-id"
}

variable "ingestion_storage_identity_name" {
  description = "The name of the ingestion storage identity"
  type        = string
  default     = "storage-id"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the AKS cluster"
  type        = string
  default     = "1.34.0"
}

variable "aks_segregated_node_and_pod_subnets_enabled" {
  description = "Whether to enable segregated node and pod subnets for the AKS cluster"
  type        = bool
  default     = true
}

variable "kubernetes_default_node_size" {
  description = "The default node size for the AKS cluster"
  type        = string
  default     = "Standard_D2s_v6"
}

variable "kubernetes_default_node_zones" {
  description = "The default node zones for the AKS cluster"
  type        = list(string)
  default     = ["1", "3"]
}

variable "node_resource_group_name" {
  description = "The name of the resource group for AKS nodes"
  type        = string
  default     = "resource-group-core-aks-nodes"
}

variable "prometheus_node_recording_rules" {
  description = "Node level recording rules for Prometheus monitoring"
  type = list(object({
    enabled    = optional(bool, true)
    record     = string
    expression = string
    labels     = optional(map(string))
  }))
  default = null
}

variable "prometheus_kubernetes_recording_rules" {
  description = "Kubernetes level recording rules for Prometheus monitoring"
  type = list(object({
    enabled    = optional(bool, true)
    record     = string
    expression = string
    labels     = optional(map(string))
  }))
  default = null
}

variable "prometheus_ux_recording_rules" {
  description = "UX level recording rules for Prometheus monitoring"
  type = list(object({
    enabled    = optional(bool, true)
    record     = string
    expression = string
    labels     = optional(map(string))
  }))
  default = null
}

variable "grafana_monitor_enabled" {
  description = "Whether to enable Grafana for the AKS cluster"
  type        = bool
  default     = true
}

variable "grafana_major_version" {
  description = "The major version of Grafana to use for the AKS cluster"
  type        = string
  default     = "11"
}

variable "grafana_identity_type" {
  description = "The type of the Grafana user-assigned identity"
  type        = string
  default     = "UserAssigned"
}

variable "kubernetes_node_pool_settings" {
  description = "Configuration settings for the rapid node pool"
  type = map(object({
    auto_scaling_enabled = optional(bool, true)
    max_count            = optional(number, 3)
    min_count            = optional(number, 0)
    mode                 = optional(string, "User")
    node_count           = optional(number, 0)
    node_labels = optional(object({
      lifecycle   = string
      scalability = string
      }), {
      lifecycle   = "ephemeral"
      scalability = "rapid"
    })
    node_taints     = optional(list(string), ["scalability=rapid:NoSchedule", "lifecycle=ephemeral:NoSchedule"])
    os_disk_size_gb = optional(number, 100)
    os_sku          = optional(string, "AzureLinux")
    upgrade_settings = optional(object({
      max_surge = string
      }), {
      max_surge = "10%"
    })
    vm_size = optional(string, "Standard_D8s_v4")
    zones   = optional(list(string), ["1", "3"])
  }))
  default = {}
}

variable "aks_public_ip_name" {
  description = "Name of the AKS public IP (created in day-1)"
  type        = string
  default     = "aks_public_ip"
}

variable "aks_network_profile_idle_timeout_in_minutes" {
  description = "The idle timeout in minutes for the AKS network profile"
  type        = number
  default     = 100
}

variable "grafana_identity_name" {
  description = "The name of the Grafana user-assigned identity"
  type        = string
  default     = "grafana-id"
}

variable "psql_user_assigned_identity_name" {
  description = "The name of the PostgreSQL user-assigned identity"
  type        = string
  default     = "psql-id"
}

variable "psql_private_dns_zone_name" {
  description = "Name of the PostgreSQL private DNS zone (created in day-1)"
  type        = string
  default     = "psql.postgres.database.azure.com"
}

# PostgreSQL Configuration
variable "postgresql_server_name" {
  description = "The name of the PostgreSQL server"
  type        = string
  default     = "psql"
}

variable "postgresql_zone" {
  description = "The availability zone for the PostgreSQL server"
  type        = string
  default     = "1"
}

variable "postgresql_version" {
  description = "The version of PostgreSQL to use"
  type        = string
  default     = "14"
}

variable "postgresql_sku" {
  description = "The SKU for the PostgreSQL server"
  type        = string
  default     = "GP_Standard_D2ds_v5"
}

variable "postgresql_storage_mb" {
  description = "The storage size in MB for the PostgreSQL server"
  type        = number
  default     = 32768
}

variable "postgresql_backup_retention_days" {
  description = "The number of days to retain backups for the PostgreSQL server"
  type        = number
  default     = 7
}

variable "postgresql_databases" {
  description = "Map of databases and their properties"
  type = map(object({
    name            = string
    collation       = optional(string, null)
    charset         = optional(string, null)
    lifecycle       = optional(bool, false)
    prevent_destroy = optional(bool, true)
  }))
  default = {
    "chat" = {
      name            = "chat"
      prevent_destroy = false
    }
    "ingestion" = {
      name            = "ingestion"
      prevent_destroy = false
    }
    "theme" = {
      name            = "theme"
      prevent_destroy = false
    }
    "scope-management" = {
      name            = "scope-management"
      prevent_destroy = false
    }
    "app-repository" = {
      name            = "app-repository"
      prevent_destroy = false
    }
  }
}

variable "postgresql_server_tags" {
  description = "Additional tags that apply only to the PostgreSQL server"
  type        = map(string)
  default     = {}
}

variable "postgresql_metric_alerts_external_action_group_ids" {
  description = "List of external Action Group IDs to apply to all PostgreSQL metric alerts"
  type        = list(string)
  default     = []
}

variable "postgres_username" {
  description = "The username for the PostgreSQL server"
  type = object({
    length  = number
    special = bool
    numeric = bool
  })
  default = {
    length  = 16
    special = false
    numeric = false
  }
}

variable "postgres_password" {
  description = "The password for the PostgreSQL server"
  type = object({
    length  = number
    special = bool
    numeric = bool
  })
  default = {
    length  = 32
    special = false
    numeric = false
  }
}

variable "csi_identity_name" {
  description = "Name of the CSI identity"
  type        = string
  default     = "csi-id"
}

# GitOps Configuration
variable "gitops_display_name" {
  description = "Display name for GitOps application registration"
  type        = string
}

# Access Control
variable "cluster_admin_user_ids" {
  description = "List of user object IDs that will be granted cluster administrator permissions"
  type        = list(string)
}

variable "gitops_maintainer_user_ids" {
  description = "List of user object IDs that will be granted GitOps maintainer permissions"
  type        = list(string)
}

variable "keyvault_secret_writer_user_ids" {
  description = "List of user object IDs that will be granted permissions to write secrets to Key Vault"
  type        = list(string)
}

variable "telemetry_observer_user_ids" {
  description = "List of user object IDs that will be granted permissions to view telemetry data"
  type        = list(string)
}

variable "env" {
  description = "Environment name (e.g., dev, test or prod)"
  type        = string
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "uqhacr"
}

variable "container_registry_sku" {
  description = "SKU of the Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "container_registry_admin_enabled" {
  description = "Whether to enable admin access to the Azure Container Registry"
  type        = bool
  default     = false
}

variable "container_registry_identity_type" {
  description = "Type of the Azure Container Registry identity"
  type        = string
  default     = "SystemAssigned"
}

variable "registry_diagnostic_name" {
  description = "Name of the diagnostic setting for the Container Registry"
  type        = string
  default     = "log-helloazure"
}

variable "redis_name" {
  description = "Name of the Azure Redis Cache instance"
  type        = string
  default     = "uqharedis"
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Redis Cache"
  type        = bool
  default     = true
}

variable "ingestion_cache_sa_name" {
  description = "Name of the storage account used for ingestion cache"
  type        = string
  default     = "uqhacache"
}

variable "ingestion_storage_sa_name" {
  description = "Name of the storage account used for ingestion storage"
  type        = string
  default     = "uqhastorage"
}

variable "ingestion_cache_connection_string_1_secret_name" {
  description = "Secret name for ingestion cache connection string 1"
  type        = string
  default     = "ingestion-cache-connection-string-1"
}

variable "ingestion_cache_connection_string_2_secret_name" {
  description = "Secret name for ingestion cache connection string 2"
  type        = string
  default     = "ingestion-cache-connection-string-2"
}

variable "ingestion_storage_connection_string_1_secret_name" {
  description = "Secret name for ingestion storage connection string 1"
  type        = string
  default     = "ingestion-storage-connection-string-1"
}

variable "ingestion_storage_connection_string_2_secret_name" {
  description = "Secret name for ingestion storage connection string 2"
  type        = string
  default     = "ingestion-storage-connection-string-2"
}

variable "speech_service_private_dns_zone_name" {
  description = "The name of the private DNS zone for the speech service"
  type        = string
  default     = "privatelink.cognitiveservices.azure.com"
}

variable "speech_service_private_dns_zone_virtual_network_link_name" {
  description = "The name of the virtual network link for the speech service private DNS zone"
  type        = string
  default     = "speech-service-private-dns-zone-vnet-link"
}

variable "speech_service_custom_subdomain_name" {
  description = "The custom subdomain name to use for the speech service"
  type        = string
  default     = "ss-hello-azure"
}

# OpenAI Configuration
variable "openai_endpoint_secret_name_suffix" {
  description = "Suffix for OpenAI endpoint secret names in Key Vault"
  type        = string
  default     = "-ep"
}

variable "openai_cognitive_accounts" {
  description = "Map of Azure OpenAI cognitive accounts configuration"
  type = map(object({
    name                          = string
    location                      = string
    local_auth_enabled            = bool
    custom_subdomain_name         = optional(string)
    public_network_access_enabled = bool
    cognitive_deployments = list(object({
      name          = string
      model_name    = string
      model_version = string
      sku_name      = optional(string)
      sku_capacity  = number
    }))
  }))
  default = {
    "cognitive-account-swedencentral" = {
      name                          = "cognitive-account-swedencentral"
      location                      = "swedencentral"
      local_auth_enabled            = false
      custom_subdomain_name         = null
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
}

# Document Intelligence Configuration
variable "document_intelligence_name" {
  description = "Name of the Document Intelligence service"
  type        = string
  default     = "doc-intelligence"
}

variable "document_intelligence_accounts" {
  description = "Map of Document Intelligence accounts configuration"
  type = map(object({
    location                      = string
    custom_subdomain_name         = optional(string)
    public_network_access_enabled = bool
    local_auth_enabled            = bool
  }))
  default = {
    "swedencentral-form-recognizer" = {
      location                      = "swedencentral"
      custom_subdomain_name         = null
      public_network_access_enabled = true
      local_auth_enabled            = true
    }
  }
}

# Speech Service Configuration
variable "speech_service_name" {
  description = "Name of the Speech Service"
  type        = string
  default     = "speech-service"
}

variable "speech_service_accounts" {
  description = "Map of Speech Service accounts configuration"
  type = map(object({
    location              = string
    account_kind          = string
    account_sku_name      = string
    custom_subdomain_name = optional(string)
    private_endpoint      = optional(bool)
    diagnostic_settings = optional(object({
      log_analytics_workspace_id = string
      enabled_log_categories     = list(string)
    }))
  }))
  default = {
    "swedencentral-speech" = {
      location              = "swedencentral"
      account_kind          = "SpeechServices"
      account_sku_name      = "S0"
      custom_subdomain_name = null
      private_endpoint      = true
      diagnostic_settings   = null
    }
  }
}

variable "subnet_cognitive_services_id" {
  description = "Subnet name for cognitive services private endpoints"
  type        = string
  default     = "snet-cognitive-services"
}

variable "vnet_id" {
  description = "Virtual network name for cognitive services private endpoints"
  type        = string
  default     = "vnet-001"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostic settings"
  type        = string
  default     = ""
}

# Azure AD Groups
variable "telemetry_observer_group_display_name" {
  description = "Display name for the Telemetry Observer group"
  type        = string
  default     = "Telemetry Observer"
}

variable "sensitive_data_observer_group_display_name" {
  description = "Display name for the Sensitive Data Observer group"
  type        = string
  default     = "Sensitive Data Observer"
}

variable "devops_group_display_name" {
  description = "Display name for the DevOps group"
  type        = string
  default     = "DevOps"
}

variable "emergency_admin_group_display_name" {
  description = "Display name for the Emergency Admin group"
  type        = string
  default     = "Emergency Admin"
}

variable "admin_kubernetes_cluster_group_display_name" {
  description = "Display name for the Admin Kubernetes Cluster group"
  type        = string
  default     = "Admin Kubernetes Cluster"
}

variable "main_keyvault_secret_writer_group_display_name" {
  description = "Display name for the Main Key Vault writer group"
  type        = string
  default     = "Main KeyVault writer"
}

# Application Registration
variable "application_registration_gitops_display_name" {
  description = "Display name for the GitOps application registration"
  type        = string
}

variable "application_secret_display_name" {
  description = "Display name for the GitOps application secret"
  type        = string
  default     = "gitops"
}

# Federated Identity Credentials
variable "cluster_workload_identities" {
  description = "Workload Identities to be federated into the cluster"
  type = map(object({
    name      = string
    namespace = string
  }))
  default = {
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
}

########################################################
# Secrets Configuration
########################################################
# Key Vault Secrets Configuration
variable "rabbitmq_password_chat_secret_name" {
  description = "The name of the secret containing the RabbitMQ password for chat service"
  type        = string
  default     = "rabbitmq-password-chat"
}

variable "zitadel_db_user_password_secret_name" {
  description = "The name of the secret containing the Zitadel database user password"
  type        = string
  default     = "zitadel-db-user-password"
}

variable "zitadel_master_key_secret_name" {
  description = "The name of the secret containing the Zitadel master key"
  type        = string
  default     = "zitadel-master-key"
}

variable "encryption_key_app_repository_secret_name" {
  description = "The name of the secret containing the application repository encryption key"
  type        = string
  default     = "encryption-key-app-repository"
}

variable "encryption_key_node_chat_lxm_secret_name" {
  description = "The name of the secret containing the node chat LXM encryption key"
  type        = string
  default     = "encryption-key-chat-lxm"
}

variable "encryption_key_ingestion_secret_name" {
  description = "The name of the secret containing the ingestion encryption key"
  type        = string
  default     = "encryption-key-ingestion"
}

variable "zitadel_pat_secret_name" {
  description = "The name of the manual secret placeholder for Zitadel PAT (to be set manually)"
  type        = string
  default     = "manual-zitadel-scope-mgmt-pat"
}

# Secret Generation Configuration
variable "secret_password_length" {
  description = "Default length for generated passwords"
  type        = number
  default     = 32
}

variable "rabbitmq_password_chat_length" {
  description = "Default length for RabbitMQ generated password"
  type        = number
  default     = 24
}

variable "secret_expiration_date" {
  description = "Expiration date for secrets (RFC3339 format)"
  type        = string
  default     = "2099-12-31T23:59:59Z"
}

variable "acr_push_role_name" {
  description = "Role name for the ACR push permissions"
  type        = string
  default     = "AcrPush"
}

variable "monitor_metrics_reader_role_definition_name" {
  description = "Role definition name for the monitor metrics reader"
  type        = string
  default     = "Monitoring Data Reader"
}

variable "ingestion_cache_access_tier" {
  description = "Access tier for the ingestion cache account"
  type        = string
  default     = "Hot"
}

variable "ingestion_cache_account_replication_type" {
  description = "Account replication type for the ingestion cache account"
  type        = string
  default     = "LRS"
}

variable "ingestion_cache_backup_vault" {
  description = "Backup vault for the ingestion cache account. Set to null to disable backup."
  type = object({
    name = string
  })
  default  = null
  nullable = true
}

variable "ingestion_cache_public_network_access_enabled" {
  description = "Public network access enabled for the ingestion cache account"
  type        = bool
  default     = true
}

variable "ingestion_cache_data_protection_settings" {
  description = "Data protection settings for the ingestion cache account"
  type = object({
    change_feed_enabled                  = bool
    change_feed_retention_days           = number
    versioning_enabled                   = bool
    container_soft_delete_retention_days = number
    blob_soft_delete_retention_days      = number
    point_in_time_restore_days           = number
  })
  default = {
    change_feed_enabled                  = false
    change_feed_retention_days           = 0
    versioning_enabled                   = false
    container_soft_delete_retention_days = 7
    blob_soft_delete_retention_days      = 7
    point_in_time_restore_days           = -1
  }
}

variable "ingestion_cache_storage_management_policy_default" {
  description = "Storage management policy default for the ingestion cache account"
  type = object({
    enabled                                  = bool
    blob_to_cool_after_last_modified_days    = number
    blob_to_cold_after_last_modified_days    = number
    blob_to_archive_after_last_modified_days = number
    blob_to_deleted_after_last_modified_days = number
  })
  default = {
    enabled                                  = true
    blob_to_cool_after_last_modified_days    = 1
    blob_to_cold_after_last_modified_days    = 2
    blob_to_archive_after_last_modified_days = 3
    blob_to_deleted_after_last_modified_days = 5
  }
}

variable "ingestion_cache_self_cmk_key_name" {
  description = "Self CMK for the ingestion cache account"
  type        = string
  default     = "ingestion-cache-cmk"
}

variable "ingestion_storage_access_tier" {
  description = "Access tier for the ingestion storage account"
  type        = string
  default     = "Hot"
}

variable "ingestion_storage_account_replication_type" {
  description = "Account replication type for the ingestion storage account"
  type        = string
  default     = "LRS"
}

variable "ingestion_storage_backup_vault" {
  description = "Backup vault for the ingestion storage account. Set to null to disable backup."
  type = object({
    name = string
  })
  default  = null
  nullable = true
}

variable "ingestion_storage_public_network_access_enabled" {
  description = "Public network access enabled for the ingestion storage account"
  type        = bool
  default     = true
}

variable "ingestion_storage_data_protection_settings" {
  description = "Data protection settings for the ingestion storage account"
  type = object({
    change_feed_enabled                  = bool
    change_feed_retention_days           = number
    versioning_enabled                   = bool
    container_soft_delete_retention_days = number
    blob_soft_delete_retention_days      = number
    point_in_time_restore_days           = number
  })
  default = {
    change_feed_enabled                  = false
    change_feed_retention_days           = 0
    versioning_enabled                   = false
    container_soft_delete_retention_days = 7
    blob_soft_delete_retention_days      = 7
    point_in_time_restore_days           = -1
  }
}

variable "ingestion_storage_storage_management_policy_default" {
  description = "Storage management policy default for the ingestion storage account"
  type = object({
    enabled                                  = bool
    blob_to_cool_after_last_modified_days    = number
    blob_to_cold_after_last_modified_days    = number
    blob_to_archive_after_last_modified_days = number
    blob_to_deleted_after_last_modified_days = number
  })
  default = {
    enabled                                  = true
    blob_to_cool_after_last_modified_days    = 7
    blob_to_cold_after_last_modified_days    = 14
    blob_to_archive_after_last_modified_days = 30
    blob_to_deleted_after_last_modified_days = 5 * 365
  }
}

variable "ingestion_storage_self_cmk_key_name" {
  description = "Self CMK for the ingestion storage account"
  type        = string
  default     = "ingestion-storage-cmk"
}

variable "application_gateway_public_ip_name_allocation_method" {
  description = "Allocation method for the public IP for the Application Gateway"
  type        = string
  default     = "Static"
}

variable "application_gateway_public_ip_name_sku" {
  description = "SKU for the public IP for the Application Gateway"
  type        = string
  default     = "Standard"
}

variable "application_gateway_autoscale_configuration_max_capacity" {
  description = "Max capacity for the autoscale configuration for the Application Gateway"
  type        = number
  default     = 2
}

variable "application_gateway_sku" {
  description = "SKU for the Application Gateway"
  type = object({
    name = string
    tier = string
  })
  default = {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
}

variable "application_gateway_sku_name" {
  description = "Name of the gateway IP configuration for the Application Gateway"
  type        = string
  default     = "gateway-ip-configuration"
}

variable "application_gateway_gateway_ip_configuration_name" {
  description = "Name of the gateway IP configuration for the Application Gateway"
  type        = string
  default     = "gateway-ip-configuration"
}

variable "application_gateway_frontend_ip_configuration_name" {
  description = "Name suffix for the frontend IP configuration of the Application Gateway. The full name will be constructed using the custom_subdomain_name, environment, and this value."
  type        = string
  default     = "feip"
}

variable "application_gateway_waf_policy_settings" {
  description = "Explicit name for the WAF policy settings for the Application Gateway"
  type = object({
    explicit_name               = string
    mode                        = string
    file_upload_limit_in_mb     = number
    max_request_body_size_in_kb = number
  })
  default = {
    explicit_name               = "default-waf-policy-name"
    mode                        = "Detection"
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 1024
  }
}

# Role Assignments
variable "key_reader_key_vault_role_name" {
  description = "Role name for the key reader key vault"
  type        = string
  default     = "Key Vault Secrets Officer"
}

variable "secret_reader_key_vault_role_name" {
  description = "Role name for the secret reader key vault"
  type        = string
  default     = "Key Vault Secrets User"
}

variable "key_manager_key_vault_role_name" {
  description = "Role name for the key manager key vault"
  type        = string
  default     = "Key Vault Crypto Officer"
}

variable "secret_manager_key_vault_role_name" {
  description = "Role name for the secret manager key vault"
  type        = string
  default     = "Key Vault Secrets Officer"
}

variable "access_manager_key_vault_role_name" {
  description = "Role name for the access manager key vault"
  type        = string
  default     = "Key Vault Data Access Administrator"
}

variable "cluster_user_role_name" {
  description = "Role name for the cluster user"
  type        = string
  default     = "Azure Kubernetes Service Contributor Role"
}

variable "cluster_rbac_admin_role_name" {
  description = "Role name for the cluster RBAC admin"
  type        = string
  default     = "Azure Kubernetes Service RBAC Cluster Admin"
}

variable "key_vault_crypto_service_encryption_user_role_name" {
  description = "Role name for Key Vault Crypto Service Encryption User"
  type        = string
  default     = "Key Vault Crypto Service Encryption User"
}
