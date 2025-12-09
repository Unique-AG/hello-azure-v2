# Day-3 specific parameters
env = "dev"

# Tags
tags = {
  app = "hello-azure"
}

# Resource locations
resource_group_core_location = "swedencentral"
resource_vnet_location       = "swedencentral"

# Resource Group Names (created in day-1)
resource_group_core_name = "resource-group-core"
resource_group_name_vnet = "rg-vnet-002"

# Network Configuration (VNET created in day-1)
vnet_name = "vnet-001"

# Naming
name_prefix = "hello-azure"

# Monitoring Configuration (from day-1)
log_analytics_workspace_name = "loganalytics"

# Bastion Configuration
bastion_name                              = "bastion"
bastion_sku                               = "Standard"
bastion_tunneling_enabled                 = true
bastion_native_client_support_enabled     = true
bastion_public_ip_name                    = "bastion-pip"

