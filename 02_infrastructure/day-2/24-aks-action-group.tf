resource "azurerm_monitor_action_group" "aks_alerts" {
  name                = "${local.cluster_name}-alerts"
  resource_group_name = data.azurerm_resource_group.core.name
  short_name          = "aksalerts"

  email_receiver {
    name          = "security-events"
    email_address = var.defender_security_contact_email
  }

  tags = var.tags
}
