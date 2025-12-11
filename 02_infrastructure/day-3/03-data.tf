# Data sources for referencing existing Azure resources from day-1

data "azurerm_subscription" "current" {}

# Resource Group data sources (created in day-1)
data "azurerm_resource_group" "core" {
  name = var.resource_group_core_name
}

data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name_vnet
}

# Virtual Network data source (created in day-1)
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name_vnet
}

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

