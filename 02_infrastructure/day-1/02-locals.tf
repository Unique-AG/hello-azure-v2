# Local values that are computed or combined from variables
locals {
  # Dynamic DNS records - will be populated after application gateway is created
  # This is a placeholder that will be updated in a later phase when application gateway is created
  dns_subdomain_records_with_ip = {
    for k, v in var.dns_subdomain_records : k => {
      name    = v.name
      records = [] # Will be populated dynamically after application gateway is created
    }
  }

  # DNS Zones and Records
  dns_zones_and_records = {
    dns_zone = {
      name = var.dns_zone_name
      resource_group_name = azurerm_resource_group.vnet.name
    }
    psql_private_dns_zone = {
      name = var.psql_private_dns_zone_name
      resource_group_name = azurerm_resource_group.vnet.name
    }
    speech_service_private_dns_zone = {
      name = var.speech_service_private_dns_zone_name
      resource_group_name = azurerm_resource_group.vnet.name
    }
    dns_zone_sub_domain_records = {
      name = var.dns_zone_sub_domain_records
      resource_group_name = azurerm_resource_group.vnet.name
    }

    dns_zone_root_records = var.dns_zone_root_records
  }

  azurerm_private_dns_zone_virtual_network_link_name = var.azurerm_private_dns_zone_virtual_network_link_name

  # TAGS
  tags = var.tags
}

