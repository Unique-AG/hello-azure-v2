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


variable "budget_contact_emails" {
  description = "List of email addresses for budget notifications"
  type        = list(string)
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

variable "redis_name" {
  description = "Name of the Azure Redis Cache instance"
  type        = string
  default     = "uqharedis"
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


variable "monitor_metrics_reader_role_definition_name" {
  description = "Role definition name for the monitor metrics reader"
  type        = string
  default     = "Monitoring Data Reader"
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

variable "application_gateway_sku" {
  description = "Name of the gateway IP configuration for the Application Gateway"
  type        = string
  default     = "gateway-ip-configuration"
}

variable "application_gateway_gateway_ip_configuration_name" {
  description = "Name of the gateway IP configuration for the Application Gateway"
  type        = string
  default     = "gateway-ip-configuration"
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
