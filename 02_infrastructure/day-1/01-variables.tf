# Backend Configuration Variables
variable "subscription_id" {
  description = "The UUID ID of the suscription (not the full Azure Resource ID)."
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
  description = "The core resource group name."
  type        = string
  default     = "resource-group-core"
}

variable "resource_group_sensitive_name" {
  description = "The sensitive resource group name"
  type        = string
  default     = "resource-group-sensitive"
}

variable "resource_group_vnet_id" {
  description = "The vnet resource group id"
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
variable "kv_sku" {
  description = "SKU for Key Vault"
  type        = string
}

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
  type        = set(string)
}

variable "subscription_budget_name" {
  description = "Name of the subscription budget"
  type        = string
  default     = "subscription_budget"
}

variable "subscription_budget_amount" {
  description = "The amount for the subscription budget"
  type        = number
  default     = 2000
}

# AKS Configuration
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks"
}

variable "aks_public_ip_name" {
  description = "Name of the AKS public IP"
  type        = string
  default     = "aks_public_ip"
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

variable "speech_service_private_dns_zone_name" {
  description = "The name of the private DNS zone for the speech service."
  type        = string
}

variable "speech_service_private_dns_zone_virtual_network_link_name" {
  description = "The name of the virtual network link for the speech service private DNS zone"
  type        = string
  default     = "privatelink.cognitiveservices.azure.com"
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
