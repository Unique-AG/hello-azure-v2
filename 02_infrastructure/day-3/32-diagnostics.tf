# Diagnostic settings for Azure Bastion
# Sends logs to Log Analytics workspace for monitoring and security auditing

resource "azurerm_monitor_diagnostic_setting" "bastion" {
  name                       = "${local.bastion_name}-diagnostics"
  target_resource_id         = azurerm_bastion_host.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "BastionAuditLogs"

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}

