# Local values that are computed or combined from variables
locals {
  # Naming
  name_prefix                                 = "${var.name_prefix}-${var.env}"
  custom_subdomain_name                       = "${var.custom_subdomain_name}-${var.env}"
  document_intelligence_custom_subdomain_name = "${var.document_intelligence_custom_subdomain_name}-${var.env}"
  speech_service_custom_subdomain_name        = "${var.speech_service_custom_subdomain_name}-${var.env}"

  # Resource names

  log_analytics_workspace_name              = "${var.log_analytics_workspace_name}-${var.env}"
  aks_user_assigned_identity_name           = "${var.aks_user_assigned_identity_name}-${var.env}"
  cluster_name                              = "${var.cluster_name}-${var.env}"
  document_intelligence_identity_name       = "${var.document_intelligence_identity_name}-${var.env}"
  ingestion_cache_identity_name             = "${var.ingestion_cache_identity_name}-${var.env}"
  ingestion_storage_identity_name           = "${var.ingestion_storage_identity_name}-${var.env}"
  psql_user_assigned_identity_name          = "${var.psql_user_assigned_identity_name}-${var.env}"
  csi_identity_name                         = "${var.csi_identity_name}-${var.env}"
  grafana_identity_name                     = "${var.grafana_identity_name}-${var.env}"
  audit_storage_user_assigned_identity_name = "${var.audit_storage_user_assigned_identity_name}-${var.env}"
  container_registry_name                   = "${var.container_registry_name}${var.env}"
  redis_name                                = "${var.redis_name}-${var.env}"
  ingestion_cache_sa_name                   = "${var.ingestion_cache_sa_name}-${var.env}"
  ingestion_storage_sa_name                 = "${var.ingestion_storage_sa_name}-${var.env}"

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

  # VNET
  vnet = {
    name                = var.vnet_name
    address_space       = var.vnet_address_space
    location            = azurerm_resource_group.vnet.location
    resource_group_name = azurerm_resource_group.vnet.name

    subnets = {
      "snet-aks-pods" = {
        name              = var.subnet_aks_pods_name
        address_prefixes  = [var.subnet_aks_pods_cidr]
        service_endpoints = ["Microsoft.Storage"]
        delegation = [{
          name = "aks-delegation"
          service_delegation = {
            name    = "Microsoft.ContainerService/managedClusters"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }]
      }
      "snet-aks-nodes" = {
        name              = var.subnet_aks_nodes_name
        address_prefixes  = [var.subnet_aks_nodes_cidr]
        service_endpoints = ["Microsoft.Storage"]
      }
      "snet-agw" = {
        name             = var.subnet_agw_name
        address_prefixes = [var.subnet_agw_cidr]
      }
      "snet-cognitive" = {
        name             = var.subnet_cognitive_name
        address_prefixes = [var.subnet_cognitive_cidr]
      }
      "snet-kv" = {
        name             = var.subnet_kv_name
        address_prefixes = [var.subnet_kv_cidr]
      }
      "snet-psql" = {
        name             = var.subnet_psql_name
        address_prefixes = [var.subnet_psql_cidr]
        delegation = [{
          name = "psql-delegation"
          service_delegation = {
            name    = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }]
      }
      "snet-redis" = {
        name             = var.subnet_redis_name
        address_prefixes = [var.subnet_redis_cidr]
      }
      "snet-storage" = {
        name             = var.subnet_storage_name
        address_prefixes = [var.subnet_storage_cidr]
      }
      "snet-github" = {
        name                                          = var.subnet_github_name
        address_prefixes                              = [var.subnet_github_cidr]
        private_link_service_network_policies_enabled = true
        private_endpoint_network_policies             = "Disabled"
        default_outbound_access_enabled               = true
        delegation = [{
          name = "delegation"
          service_delegation = {
            name = "GitHub.Network/networkSettings"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
            ]
          }
        }]
      }
    }
  }

  # DNS Zones and Records
  dns_zones_and_records = {
    dns_zone = {
      name = var.dns_zone_name
    }
    psql_private_dns_zone = {
      name = var.psql_private_dns_zone_name
    }
  }

  azurerm_private_dns_zone_virtual_network_link_name = var.azurerm_private_dns_zone_virtual_network_link_name

  # Key Vaults
  key_vault_core = {
    tenant_id                   = data.azurerm_subscription.current.tenant_id
    name                        = "${var.main_kv_name}${var.env}"
    resource_group_name         = var.resource_group_core_name
    enabled_for_disk_encryption = var.keyvault_core_enabled_for_disk_encryption
    soft_delete_retention_days  = var.keyvault_core_soft_delete_retention_days
    purge_protection_enabled    = var.keyvault_core_purge_protection_enabled
    sku_name                    = var.kv_sku
    tags                        = var.tags
    rbac_authorization_enabled  = var.keyvault_core_rbac_authorization_enabled
    network_acls                = var.keyvault_core_network_acls
  }

  key_vault_sensitive = {
    tenant_id                   = data.azurerm_subscription.current.tenant_id
    name                        = "${var.sensitive_kv_name}${var.env}"
    resource_group_name         = var.resource_group_sensitive_name
    enabled_for_disk_encryption = var.keyvault_sensitive_enabled_for_disk_encryption
    soft_delete_retention_days  = var.keyvault_sensitive_soft_delete_retention_days
    purge_protection_enabled    = var.keyvault_sensitive_purge_protection_enabled
    sku_name                    = var.kv_sku
    tags                        = var.tags
    rbac_authorization_enabled  = var.keyvault_sensitive_rbac_authorization_enabled
    network_acls                = var.keyvault_sensitive_network_acls
  }

  # Azure resource provider registrations
  azure_resource_provider_registrations = {
    azure_dashboard_provider = {
      name = "Microsoft.Dashboard"
    }
    azure_monitor_provider = {
      name = "Microsoft.Monitor"
    }
    azure_alerts_provider = {
      name = "Microsoft.AlertsManagement"
    }
  }

  # TAGS
  tags = var.tags
}

