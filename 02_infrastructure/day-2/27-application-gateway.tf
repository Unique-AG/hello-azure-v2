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
  source        = "github.com/Unique-AG/terraform-modules.git//modules/azure-application-gateway?depth=1&ref=azure-application-gateway-4.4.1"
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

  # Ensure diagnostics are configured so the resource is not planned for destroy (count stays = 1)
  # TODO: Uncomment once diagnostic setting exists in Azure (currently causes drift)
  # monitor_diagnostic_setting = {
  #   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
  #   enabled_log = [
  #     {
  #       category_group = "allLogs"
  #     }
  #   ]
  # }

  tags = var.tags

  depends_on = [
    azurerm_public_ip.application_gateway_public_ip
  ]
}


