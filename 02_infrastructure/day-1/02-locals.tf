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
}

