# Local values that are computed or combined from variables
locals {
  # Environment-derived values - computed directly from var.env (var.env is required)
  # Key Vault names - use provided values if set, otherwise compute from var.env
  main_kv_name      = var.main_kv_name != null ? var.main_kv_name : "hakv1${var.env}v2"
  sensitive_kv_name = var.sensitive_kv_name != null ? var.sensitive_kv_name : "hakv2${var.env}v2"

  # Dynamic DNS records - will be populated after application gateway is created
  # This is a placeholder that will be updated in a later phase when application gateway is created
  dns_subdomain_records_with_ip = {
    for k, v in var.dns_subdomain_records : k => {
      name    = v.name
      records = [] # Will be populated dynamically after application gateway is created
    }
  }
}

