# PostgreSQL Flexible Server
# Using the azure-postgresql module from terraform-modules

resource "random_string" "psql_suffix" {
  length = 8
  # Note: These values match the existing resource in state to prevent replacement
  # The existing resource was created with special=true and upper=true
  special = true
  upper   = true
}

resource "random_password" "postgres_username" {
  length  = var.postgres_username.length
  special = var.postgres_username.special
  numeric = var.postgres_username.numeric
}

resource "random_password" "postgres_password" {
  length  = var.postgres_password.length
  special = var.postgres_password.special
  numeric = var.postgres_password.numeric
}

module "postgresql" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-postgresql?ref=azure-postgresql-3.1.0"

  name                = "${var.postgresql_server_name}-${random_string.psql_suffix.result}"
  resource_group_name = data.azurerm_resource_group.sensitive.name
  location            = data.azurerm_resource_group.sensitive.location

  administrator_login = random_password.postgres_username.result
  admin_password      = random_password.postgres_password.result

  delegated_subnet_id = data.azurerm_subnet.postgresql.id
  private_dns_zone_id = data.azurerm_private_dns_zone.postgresql.id

  zone                          = var.postgresql_zone
  flex_pg_version               = var.postgresql_version
  flex_sku                      = var.postgresql_sku
  flex_storage_mb               = var.postgresql_storage_mb
  flex_pg_backup_retention_days = var.postgresql_backup_retention_days

  identity_ids = [data.azurerm_user_assigned_identity.psql_identity.id]
  key_vault_id = data.azurerm_key_vault.key_vault_sensitive.id

  databases = var.postgresql_databases

  tags                   = var.tags
  postgresql_server_tags = var.postgresql_server_tags

  metric_alerts_external_action_group_ids = var.postgresql_metric_alerts_external_action_group_ids

  # Configure metric alerts to match existing alerts in Azure
  # Only include CPU and Memory alerts (exclude absence alert which doesn't exist yet)
  metric_alerts = {
    default_cpu_alert = {
      name        = "PostgreSQL High CPU Usage"
      description = "Alert when CPU usage is above 80% for more than 30 minutes"
      severity    = 2
      frequency   = "PT5M"
      window_size = "PT30M"
      enabled     = true
      criteria = {
        metric_name = "cpu_percent"
        aggregation = "Average"
        operator    = "GreaterThan"
        threshold   = 80
      }
    }
    default_memory_alert = {
      name        = "PostgreSQL High Memory Usage"
      description = "Alert when memory usage is above 90% for more than 1 hour"
      severity    = 1
      frequency   = "PT15M"
      window_size = "PT1H"
      enabled     = true
      criteria = {
        metric_name = "memory_percent"
        aggregation = "Average"
        operator    = "GreaterThan"
        threshold   = 90
      }
    }

  }

}

