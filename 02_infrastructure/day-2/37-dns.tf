# DNS A Records
# DNS A records for the public DNS zone, pointing to the Application Gateway public IP

resource "azurerm_dns_a_record" "adnsar_root" {
  name                = "@"
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.application_gateway_public_ip.ip_address]
  tags                = var.tags
}

resource "azurerm_dns_a_record" "adnsar_sub_domains" {
  for_each            = var.dns_subdomain_records
  name                = each.value.name
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.application_gateway_public_ip.ip_address]
  tags                = var.tags
}
