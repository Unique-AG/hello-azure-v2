# Local values that are computed or combined from variables
locals {
  # DNS and naming
  dns_zone_name                       = "${var.env}-${var.dns_zone_name}"
  name_prefix                         = "${var.custom_subdomain_name}-${var.env}"
  custom_subdomain_name               = "${var.custom_subdomain_name}-${var.env}"
  document_intelligence_custom_subdomain_name = "${var.document_intelligence_custom_subdomain_name}-${var.env}"
  speech_service_custom_subdomain_name = "${var.speech_service_custom_subdomain_name}-${var.env}"

  # Resource names
  log_analytics_workspace_name        = "${var.log_analytics_workspace_name}-${var.env}"
  aks_user_assigned_identity_name     =  "${var.aks_user_assigned_identity_name}-${var.env}"
  cluster_name                        = "${var.cluster_name}-${var.env}"
  document_intelligence_identity_name = "${var.document_intelligence_identity_name}-${var.env}"
  ingestion_cache_identity_name       = "${var.ingestion_cache_identity_name}-${var.env}"
  ingestion_storage_identity_name     = "${var.ingestion_storage_identity_name}-${var.env}"
  psql_user_assigned_identity_name    = "${var.psql_user_assigned_identity_name}-${var.env}"
  csi_identity_name                   = "${var.csi_identity_name}-${var.env}"
  grafana_identity_name               = "${var.grafana_identity_name}-${var.env}"
  container_registry_name             = "${var.container_registry_name}${var.env}"
  redis_name                          = "${var.redis_name}-${var.env}"
  ingestion_cache_sa_name             = "${var.ingestion_cache_sa_name}${var.env}"
  ingestion_storage_sa_name           = "${var.ingestion_storage_sa_name}${var.env}"
  
  key_vault_core = {
      name                = "${var.main_kv_name}${var.env}v2"
      resource_group_name = var.resource_group_core_name
  }

  key_vault_sensitive = {
    name                = "${var.sensitive_kv_name}${var.env}v2"
    resource_group_name = var.resource_group_sensitive_name
  }

  aks = {
    name                = "${var.cluster_name}-${var.env}"
    resource_group_name = var.resource_group_core_name
  }

  dns_zone = {
    name                = "${var.dns_zone_name}-${var.env}"
    resource_group_name = var.resource_group_name_vnet
  }

  # Link names
  speech_service_private_dns_zone_virtual_network_link_name = "${var.speech_service_private_dns_zone_virtual_network_link_name}-${var.env}"

  # Application registration
  application_secret_display_name = "${var.custom_subdomain_name}-${var.env}-${var.application_secret_display_name}"

  # Dynamic DNS records - will be populated after application gateway is created
  # This is a placeholder that will be updated in a later phase when application gateway is created
  dns_subdomain_records_with_ip = {
    for k, v in var.dns_subdomain_records : k => {
      name    = v.name
      records = [] # Will be populated dynamically after application gateway is created
    }
  }
}

