# Virtual Network and Subnets
# Using the Azure VNET module from Azure/avm-res-network-virtualnetwork

# -- use https://www.davidc.net/sites/default/subnets/subnets.html to calculate the CIDR ranges
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "v0.7.1"

  name                = local.vnet.name
  address_space       = local.vnet.address_space
  location            = local.vnet.location
  resource_group_name = local.vnet.resource_group_name

  subnets = local.vnet.subnets
}

