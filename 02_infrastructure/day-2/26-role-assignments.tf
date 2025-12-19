# PostgreSQL Identity Key Vault Key Reader
resource "azurerm_role_assignment" "psql_identity_role_assignment" {
  principal_id         = data.azurerm_user_assigned_identity.psql_identity.principal_id
  role_definition_name = local.key_vault_crypto_service_encryption_user_role_name
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
}

# Ingestion Cache Identity Key Vault assignments
resource "azurerm_role_assignment" "ingestion_cache_kv_key_reader" {
  principal_id         = data.azurerm_user_assigned_identity.ingestion_cache_identity.principal_id
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
  role_definition_name = local.secret_reader_key_vault_role_name
}

resource "azurerm_role_assignment" "ingestion_cache_kv_secrets_reader" {
  principal_id         = data.azurerm_user_assigned_identity.ingestion_cache_identity.principal_id
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
  role_definition_name = local.secret_reader_key_vault_role_name
}

# Ingestion Storage Identity Key Vault assignments
resource "azurerm_role_assignment" "ingestion_storage_kv_key_reader" {
  principal_id         = data.azurerm_user_assigned_identity.ingestion_storage_identity.principal_id
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
  role_definition_name = local.key_vault_crypto_service_encryption_user_role_name
}

resource "azurerm_role_assignment" "ingestion_storage_kv_secrets_reader" {
  principal_id         = data.azurerm_user_assigned_identity.ingestion_storage_identity.principal_id
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
  role_definition_name = local.secret_reader_key_vault_role_name
}

# Terraform Service Principal Key Vault assignments
resource "azurerm_role_assignment" "kv_main_crypto_officer_terraform_assign" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.key_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

resource "azurerm_role_assignment" "kv_main_secrets_officer_terraform_assign" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.secret_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

resource "azurerm_role_assignment" "kv_main_access_administrator_terraform_assign" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.access_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

resource "azurerm_role_assignment" "kv_crypto_officer_terraform_assign" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.key_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
}

resource "azurerm_role_assignment" "kv_secrets_officer_terraform_assign" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.secret_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
}

resource "azurerm_role_assignment" "kv_access_administrator_terraform_assign" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.access_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
}

# Terraform Service Principal ACR Push assignment
resource "azurerm_role_assignment" "acrpush_terraform" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = var.acr_push_role_name
  scope                = data.azurerm_resource_group.core.id
}

resource "azurerm_role_assignment" "main_keyvault_secret_manager_group" {
  principal_id         = azuread_group.main_keyvault_secret_writer.object_id
  role_definition_name = local.secret_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

resource "azurerm_role_assignment" "telemetry_observer_group" {
  principal_id         = azuread_group.telemetry_observer.object_id
  scope                = data.azurerm_resource_group.core.id
  role_definition_name = data.azurerm_role_definition.telemetry_observer.name
}

resource "azurerm_role_assignment" "main_keyvault_key_reader_users" {
  for_each             = data.azuread_user.main_keyvault_secret_writer
  principal_id         = each.value.object_id
  role_definition_name = local.key_reader_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

resource "azurerm_role_assignment" "main_keyvault_secret_manager_users" {
  for_each             = data.azuread_user.main_keyvault_secret_writer
  principal_id         = each.value.object_id
  role_definition_name = local.secret_manager_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

resource "azurerm_role_assignment" "telemetry_observer_users" {
  for_each             = data.azuread_user.telemetry_observer
  principal_id         = each.value.object_id
  scope                = data.azurerm_resource_group.core.id
  role_definition_name = data.azurerm_role_definition.telemetry_observer.name
}

# Monitoring Data Reader assignment for Grafana Identity
resource "azurerm_role_assignment" "monitor_metrics_reader" {
  scope                = data.azurerm_resource_group.core.id
  role_definition_name = var.monitor_metrics_reader_role_definition_name
  principal_id         = data.azurerm_user_assigned_identity.grafana_identity.principal_id
}

