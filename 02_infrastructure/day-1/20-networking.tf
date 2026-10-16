# Virtual Network and Subnets
# Using the Azure VNET module from Azure/avm-res-network-virtualnetwork

# -- use https://www.davidc.net/sites/default/subnets/subnets.html to calculate the CIDR ranges
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.22.3" # not 0.22.2: its ignore_changes freezes the vnet properties

  name          = local.vnet.name
  address_space = local.vnet.address_space
  location      = local.vnet.location
  parent_id     = local.vnet.parent_id

  subnets = local.vnet.subnets
}

