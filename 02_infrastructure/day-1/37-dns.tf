# DNS Zones and Records
# Public DNS zone, private DNS zones for PostgreSQL and Speech Service, and DNS records

resource "azurerm_private_dns_zone" "psql_private_dns_zone" {
  name                = local.dns_zones_and_records.psql_private_dns_zone.name
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql-private-dns-zone-vnet-link" {
  name                  = local.azurerm_private_dns_zone_virtual_network_link_name
  private_dns_zone_name = azurerm_private_dns_zone.psql_private_dns_zone.name
  virtual_network_id    = module.vnet.resource_id
  resource_group_name   = azurerm_resource_group.vnet.name
  depends_on            = [module.vnet]
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = local.dns_zones_and_records.dns_zone.name
  resource_group_name = azurerm_resource_group.vnet.name
  tags                = local.tags
}

resource "azurerm_dns_a_record" "adnsar_root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.vnet.name
  ttl                 = 300
  records             = tolist(local.dns_zones_and_records.dns_zone_root_records)
  tags                = local.tags
}

resource "azurerm_dns_a_record" "adnsar_sub_domains" {
  for_each            = local.dns_zones_and_records.dns_zone_sub_domain_records
  name                = each.value.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.vnet.name
  ttl                 = 300
  records             = tolist(each.value.records)
  tags                = local.tags
}

resource "azurerm_private_dns_zone" "speech_service_private_dns_zone" {
  name                = var.speech_service_private_dns_zone_name
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "speech_service_private_dns_zone_vnet_link" {
  name                  = var.speech_service_private_dns_zone_virtual_network_link_name
  private_dns_zone_name = var.speech_service_private_dns_zone_name
  virtual_network_id    = module.vnet.resource_id
  resource_group_name   = azurerm_resource_group.vnet.name
  depends_on            = [module.vnet]
}

