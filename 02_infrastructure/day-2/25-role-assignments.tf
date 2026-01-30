# PostgreSQL Identity Key Vault Key Reader
resource "azurerm_role_assignment" "psql_identity_role_assignment" {
  principal_id         = data.azurerm_user_assigned_identity.psql_identity.principal_id
  role_definition_name = local.key_vault_crypto_service_encryption_user_role_name
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
}

# NOTE: CMK-related role assignments have been moved to day-1/38-role-assignments.tf
# to ensure RBAC propagation completes before day-2 attempts to use CMK

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

resource "azurerm_role_assignment" "aks_workload_identity_cognitive_services_user" {
  scope                            = data.azurerm_resource_group.core.id
  role_definition_name             = "Cognitive Services User" # matches both OpenAI and Document Intelligence / FormRecognizer
  principal_id                     = data.azurerm_user_assigned_identity.aks_workload_identity.principal_id
  skip_service_principal_aad_check = true
}

# AGIC Identity needs at least 'Reader' access to Application Gateway's Resource Group
resource "azurerm_role_assignment" "application_gateway_ingres_controller_reader_role" {
  scope                = data.azurerm_resource_group.core.id
  role_definition_name = "Reader"
  principal_id         = module.kubernetes_cluster.agic_identity_object_id
}

# AGIC Identity needs at least 'Contributor' access to Application Gateway
resource "azurerm_role_assignment" "application_gateway_ingres_controller_contributor_role" {
  scope                = module.application_gateway.appgw_id
  role_definition_name = "Contributor"
  principal_id         = module.kubernetes_cluster.agic_identity_object_id
}

# AGIC Identity needs at least 'Read and join' access to Subnet
resource "azurerm_role_assignment" "application_gateway_ingres_controller_vnet_subnet_access" {
  scope                = data.azurerm_resource_group.vnet.id
  role_definition_name = data.azurerm_role_definition.vnet_subnet_access.name
  principal_id         = module.kubernetes_cluster.agic_identity_object_id
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

# NOTE: These role assignments have been moved to day-1/38-role-assignments.tf
# to ensure users have Key Vault access before day-2 runs.
# Keeping this comment for reference.

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

# Terraform Service Principal Kubernetes assignments
# Tries to use explicit scope from variable first, then falls back to the module.kubernetes_cluster module output
resource "azurerm_role_assignment" "cluster_user_terraform" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.cluster_user_role_name
  scope                = coalesce(var.aks_cluster_id, module.kubernetes_cluster.kubernetes_cluster_id)
}

# Terraform Service Principal Kubernetes RBAC assignments
# Tries to use explicit scope from variable first, then falls back to the module.kubernetes_cluster module output
resource "azurerm_role_assignment" "cluster_rbac_admin_terraform" {
  principal_id         = data.azuread_service_principal.terraform.object_id
  role_definition_name = local.cluster_rbac_admin_role_name
  scope                = coalesce(var.aks_cluster_id, module.kubernetes_cluster.kubernetes_cluster_id)
}

# Terraform Service Principal CSI Identity Key Vault assignments
# Tries to use explicit principal_id from variable first, then falls back to the module.kubernetes_cluster module output
resource "azurerm_role_assignment" "csi_identity_secret_reader_main_kv" {
  principal_id         = coalesce(var.csi_identity_object_id, module.kubernetes_cluster.csi_identity_object_id)
  role_definition_name = local.secret_reader_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_core.id
}

# Tries to use explicit principal_id from variable first, then falls back to the module.kubernetes_cluster module output
resource "azurerm_role_assignment" "csi_identity_secret_reader" {
  principal_id         = coalesce(var.csi_identity_object_id, module.kubernetes_cluster.csi_identity_object_id)
  role_definition_name = local.secret_reader_key_vault_role_name
  scope                = data.azurerm_key_vault.key_vault_sensitive.id
}

# DNS Zone Contributor assignment for Kubelet Identity
# Tries to use explicit principal_id from variable first, then falls back to the module.kubernetes_cluster module output
resource "azurerm_role_assignment" "dns_contributor" {
  scope                            = data.azurerm_dns_zone.dns_zone.id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = coalesce(var.kubelet_identity_object_id, module.kubernetes_cluster.kublet_identity_object_id)
  skip_service_principal_aad_check = true
}

# NOTE: audit_storage_identity is created in day-1/21-managed-identities.tf
# NOTE: CMK-related role assignments have been moved to day-1/38-role-assignments.tf
