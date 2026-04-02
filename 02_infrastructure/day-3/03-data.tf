# Data sources for referencing existing Azure resources from day-1

# Subnet data source - AzureBastionSubnet (created in day-1)
data "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name_vnet
}

# Log Analytics workspace data source (created in day-1)
data "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_workspace_name
  resource_group_name = var.resource_group_core_name
}

