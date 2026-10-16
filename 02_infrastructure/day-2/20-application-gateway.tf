# Application Gateway
# Public IP and Application Gateway module for ingress traffic

resource "azurerm_public_ip" "application_gateway_public_ip" {
  name                = var.ip_name
  resource_group_name = data.azurerm_resource_group.core.name
  location            = data.azurerm_resource_group.core.location
  allocation_method   = var.application_gateway_public_ip_name_allocation_method
  sku                 = var.application_gateway_public_ip_name_sku
  tags                = var.tags
}

module "application_gateway" {
  source        = "github.com/Unique-AG/terraform-modules.git//modules/azure-application-gateway?ref=7372bfbef44fe87aa0b1a2199d70fafc9446e8e1" # azure-application-gateway-8.1.0
  name_prefix   = var.application_gateway_name
  explicit_name = local.application_gateway_name
  autoscale_configuration = {
    max_capacity = var.application_gateway_autoscale_configuration_max_capacity
  }

  resource_group = {
    name     = data.azurerm_resource_group.core.name
    location = data.azurerm_resource_group.core.location
  }

  # Keep WAF policy managed (avoid count=0 -> destroy) by ensuring WAF_v2 SKU
  sku = var.application_gateway_sku

  gateway_ip_configuration = {
    explicit_name      = var.application_gateway_gateway_ip_configuration_name
    subnet_resource_id = data.azurerm_subnet.application_gateway.id
  }

  public_frontend_ip_configuration = {
    explicit_name          = local.application_gateway_frontend_ip_configuration_name
    ip_address_resource_id = azurerm_public_ip.application_gateway_public_ip.id
  }

  # Preserve existing WAF policy name to avoid replacement
  waf_policy_settings = var.application_gateway_waf_policy_settings

  # Module 5.x defaults to blocking x-service-id at the WAF; opt out until we audit public ingress.
  waf_custom_rules_blocked_headers = []

  # 8.0.0 dropped the default 5xx alert (metric_alerts now defaults to {}); keep the 6.x one as it was.
  metric_alerts = {
    default_5xx_error_alert = {
      name        = "Application Gateway 5xx Error"
      description = "Alert when 5xx errors are above 100 for more than 1 hour"
      severity    = 1
      frequency   = "PT1M"
      window_size = "PT1H"
      enabled     = true
      criteria = {
        metric_namespace = "microsoft.network/applicationgateways"
        metric_name      = "ResponseStatus"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 100
        dimension = [{
          name     = "HttpStatusGroup"
          operator = "StartsWith"
          values   = ["5xx"]
        }]
      }
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_public_ip.application_gateway_public_ip,
    data.azurerm_subnet.application_gateway
  ]
}


