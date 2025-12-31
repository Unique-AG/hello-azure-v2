output "resource_group_core_name" {
  value       = data.azurerm_resource_group.core.name
  description = "The name of the core resource group."
}
output "oai_model_version_endpoints_secret_name" {
  value       = module.openai.model_version_endpoint_secret_name
  description = "The secret name for OAI model version endpoints."
}
output "oai_cognitive_account_endpoints_secret_names" {
  value       = module.openai.endpoints_secret_names
  description = "The secret names for OAI cognitive account endpoints."
}

output "aks_cluster_id" {
  value       = module.kubernetes_cluster.kubernetes_cluster_id
  description = "The ID of the AKS cluster."
}

# PostgreSQL outputs
output "postgresql_server_id" {
  value       = module.postgresql.postgresql_server_id
  description = "The ID of the PostgreSQL server"
}

output "postgresql_server_fqdn" {
  value       = module.postgresql.postgresql_server_fqdn
  description = "The FQDN of the PostgreSQL server"
}

output "psql_host_secret_name" {
  value       = module.postgresql.host_secret_name
  description = "The secret name for PostgreSQL host."
}

output "psql_port_secret_name" {
  value       = module.postgresql.port_secret_name
  description = "The secret name for PostgreSQL port."
}

output "psql_username_secret_name" {
  value       = module.postgresql.username_secret_name
  description = "The secret name for PostgreSQL username."
}

output "psql_password_secret_name" {
  value       = module.postgresql.password_secret_name
  description = "The secret name for PostgreSQL password."
}

output "psql_database_connection_strings_secret_names" {
  value       = module.postgresql.database_connection_strings_secret_name
  description = "The secret names for PostgreSQL database connection strings."
}

output "ingestion_cache_connection_string_1_secret_name" {
  value       = var.ingestion_cache_connection_string_1_secret_name
  description = "The secret name for ingestion cache connection string 1."
}

output "ingestion_cache_connection_string_2_secret_name" {
  value       = var.ingestion_cache_connection_string_2_secret_name
  description = "The secret name for ingestion cache connection string 2."
}

output "ingestion_storage_connection_string_1_secret_name" {
  value       = var.ingestion_storage_connection_string_1_secret_name
  description = "The secret name for ingestion storage connection string 1."
}

output "ingestion_storage_connection_string_2_secret_name" {
  value       = var.ingestion_storage_connection_string_2_secret_name
  description = "The secret name for ingestion storage connection string 2."
}

output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "The ID of the Azure Container Registry."
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server of the Azure Container Registry."
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "The name of the Azure Container Registry."
}

output "sensitive_keyvault_name" {
  value       = data.azurerm_key_vault.key_vault_sensitive.name
  description = "The name of the sensitive Key Vault."
}

output "main_keyvault_name" {
  value       = data.azurerm_key_vault.key_vault_core.name
  description = "The name of the main Key Vault."
}
output "container_registry_url" {
  value       = azurerm_container_registry.acr.login_server
  description = "The URL of the container registry."
}

output "acr_identity_principal_id" {
  value       = azurerm_container_registry.acr.identity[0].principal_id
  description = "The principal ID of the Azure Container Registry's managed identity."
}

output "aks_workload_identity_client_id" {
  value       = data.azurerm_user_assigned_identity.aks_workload_identity.client_id
  description = "The client ID of the AKS workload identity."
}
output "cluster_kublet_client_id" {
  value       = module.kubernetes_cluster.kublet_identity_client_id
  description = "The client ID of the cluster kubelet."
}

output "cluster_kublet_object_id" {
  value       = module.kubernetes_cluster.kublet_identity_object_id
  description = "The object ID of the cluster kubelet."
}

output "csi_user_assigned_identity_name" {
  value       = module.kubernetes_cluster.csi_user_assigned_identity_name
  description = "The name of the user-assigned identity for the CSI driver."
}
output "dns_zone_name_servers" {
  description = "The Name Servers for the DNS zone"
  value       = data.azurerm_dns_zone.dns_zone.name_servers
}
output "dns_zone_name" {
  description = "Name of the DNS zone"
  value       = data.azurerm_dns_zone.dns_zone.name
}

output "resource_group_vnet_name" {
  description = "Name of the resource group for the vnet"
  value       = data.azurerm_resource_group.vnet.name
}

# OpenAI Module Outputs
output "openai_cognitive_account_endpoints" {
  description = "Object containing list of endpoints"
  value       = module.openai.cognitive_account_endpoints
}

# Document Intelligence Module Outputs
output "document_intelligence_azure_document_intelligence_endpoints" {
  description = "Object containing list of endpoints"
  value       = module.document_intelligence.azure_document_intelligence_endpoints
}

output "document_intelligence_endpoint_definitions_secret_name" {
  description = "Name of the secret containing the list of objects containing endpoint definitions with name, endpoint and location."
  value       = module.document_intelligence.endpoint_definitions_secret_name
}

# Speech Service Module Outputs
output "speech_service_azure_speech_service_endpoint_definitions" {
  description = "Object containing list of objects containing endpoint definitions with name, endpoint and location."
  value       = module.speech_service.azure_speech_service_endpoint_definitions
}

output "speech_service_azure_speech_service_endpoints" {
  description = "Object containing list of endpoints."
  value       = module.speech_service.azure_speech_service_endpoints
}

# ============================================================================
# Secret Name Outputs 
# ============================================================================
output "rabbitmq_password_chat_secret_name" {
  description = "The secret name for RabbitMQ password for chat service."
  value       = azurerm_key_vault_secret.rabbitmq_password_chat.name
}

output "zitadel_db_user_password_secret_name" {
  description = "The secret name for Zitadel database user password."
  value       = azurerm_key_vault_secret.zitadel_db_user_password.name
}

output "zitadel_master_key_secret_name" {
  description = "The secret name for Zitadel master key."
  value       = azurerm_key_vault_secret.zitadel_master_key.name
}

output "encryption_key_app_repository_secret_name" {
  description = "The secret name for application repository encryption key."
  value       = azurerm_key_vault_secret.encryption_key_app_repository.name
}

output "encryption_key_node_chat_lxm_secret_name" {
  description = "The secret name for node chat LXM encryption key."
  value       = azurerm_key_vault_secret.encryption_key_node_chat_lxm.name
}

output "encryption_key_ingestion_secret_name" {
  description = "The secret name for ingestion encryption key."
  value       = azurerm_key_vault_secret.encryption_key_ingestion.name
}

output "zitadel_pat_secret_name" {
  description = "The secret name for Zitadel Personal Access Token (PAT)."
  value       = azurerm_key_vault_secret.zitadel_pat.name
}

# Application Gateway outputs
output "application_gateway_ip_address" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.application_gateway_public_ip.ip_address
}

output "application_gateway_id" {
  description = "The ID of the Application Gateway"
  value       = module.application_gateway.appgw_id
}

output "audit_storage_user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.audit_storage_identity.id
  description = "The ID of the user-assigned identity for audit storage."
}

output "azure_document_intelligence_endpoint_definitions" {
  description = "Details of the deployed doc intelligence endpoint definitions"
  value       = local.azure_document_intelligence_endpoint_definitions
}
