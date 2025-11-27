# Local values that are computed or combined from variables
locals {
  # DNS and naming
  dns_zone_name                       = "${var.env}-hello.azure.unique.dev"
  name_prefix                         = "ha-${var.env}"
  custom_subdomain_name               = "ha-${var.env}"
  document_intelligence_custom_subdomain_name = "di-ha-${var.env}"
  speech_service_custom_subdomain_name = "ss-hello-azure-${var.env}"

  # Resource names
  log_analytics_workspace_name        = "la-${var.env}"
  aks_user_assigned_identity_name     = "aks-id-${var.env}"
  cluster_name                        = "aks-${var.env}"
  document_intelligence_identity_name = "docint-id-${var.env}"
  ingestion_cache_identity_name       = "cache-id-${var.env}"
  ingestion_storage_identity_name     = "storage-id-${var.env}"
  psql_user_assigned_identity_name    = "psql-id-${var.env}"
  csi_identity_name                   = "csi-id-${var.env}"
  grafana_identity_name               = "grafana-id-${var.env}"
  main_kv_name                        = "hakv1${var.env}v2"
  sensitive_kv_name                   = "hakv2${var.env}v2"
  container_registry_name             = "uqhacr${var.env}"
  redis_name                          = "uqharedis-${var.env}"
  ingestion_cache_sa_name             = "uqhacache${var.env}"
  ingestion_storage_sa_name           = "uqhastorage${var.env}"

  # Link names
  speech_service_private_dns_zone_virtual_network_link_name = "speech-service-private-dns-zone-vnet-link-${var.env}"

  # Application registration
  application_secret_display_name = "ha-${var.env}-gitops"

  # Backend config (for use in config files)
  backend_resource_group_name = "rg-terraform-state-${var.env}"
  backend_key_day1           = "terraform-infra-${var.env}-v2-day-1.tfstate"
  backend_key_day2           = "terraform-infra-${var.env}-v2-day-2.tfstate"

  # Dynamic DNS records - will be populated after application gateway is created
  # This is a placeholder that will be updated in a later phase when application gateway is created
  dns_subdomain_records_with_ip = {
    for k, v in var.dns_subdomain_records : k => {
      name    = v.name
      records = [] # Will be populated dynamically after application gateway is created
    }
  }
}

