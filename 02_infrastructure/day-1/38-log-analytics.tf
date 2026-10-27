# Log Analytics Workspace
# Managed through the azure-log-analytics-workspace module. The module also owns the Basic-plan
# tables (AKSControlPlane, ContainerLogV2) that azure-kubernetes-service managed until 7.0.0.
# Those two tables live in Azure already and are imported into this state, not created
# (see docs/upgrades/2026-10-infrastructure-upgrade.md).

module "log_analytics" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-log-analytics-workspace?ref=d3f51f81fbf7e2dc61ac7834ba7481c44af98910" # azure-log-analytics-workspace-1.2.1

  name                         = local.log_analytics_workspace_name
  location                     = azurerm_resource_group.core.location
  resource_group_name          = azurerm_resource_group.core.name
  sku                          = var.log_analytics_sku
  retention_in_days            = var.log_analytics_retention_in_days
  local_authentication_enabled = var.log_analytics_local_authentication_enabled

  basic_log_tables = {
    AKSControlPlane = { retention_in_days = 30 }
    ContainerLogV2  = { retention_in_days = 30 }
  }

  data_collection_rule = { enabled = false }
}

moved {
  from = azurerm_log_analytics_workspace.this
  to   = module.log_analytics.azurerm_log_analytics_workspace.this
}
