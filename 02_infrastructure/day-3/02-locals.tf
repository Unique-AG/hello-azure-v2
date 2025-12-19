# Local values that are computed or combined from variables
locals {
  # Naming
  name_prefix = "${var.name_prefix}-${var.env}"

  # Resource names
  bastion_name        = "${var.bastion_name}-${local.name_prefix}"
  bastion_public_ip_name = "pip-${local.name_prefix}-${var.bastion_public_ip_name}-001"

  # Log Analytics workspace (from day-1)
  log_analytics_workspace_name = "${var.log_analytics_workspace_name}-${var.env}"

  # Tags
  tags = var.tags
}

