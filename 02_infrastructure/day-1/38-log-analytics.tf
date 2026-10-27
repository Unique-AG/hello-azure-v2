# Log Analytics Workspace
# Managed through the azure-log-analytics-workspace module. The module also owns the Basic-plan
# tables (AKSControlPlane, ContainerLogV2) that azure-kubernetes-service managed until 7.0.0.
# azurerm_log_analytics_workspace_table only sets plan and retention on tables Azure provides, so on
# an existing environment the first apply writes the same values the AKS module set and records the
# tables in this state. They must be removed from day-2 state before day-2 moves to AKS >= 7.0.0
# (see docs/upgrades/2026-10-infrastructure-upgrade.md).

module "log_analytics" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-log-analytics-workspace?ref=4878b1f5014ec92145828bebf2179f02bc7f1757" # azure-log-analytics-workspace-2.0.0

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
