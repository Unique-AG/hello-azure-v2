# Data sources for referencing existing Azure resources
data "azurerm_subscription" "current" {}

# Role definitions for custom roles
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
}

# Azure AD data sources
data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_user" "gitops_maintainer" {
  for_each  = toset(var.gitops_maintainer_user_ids)
  object_id = each.value
}

// TODO: uncomment when keyvaults are added to day-1
# data "azurerm_key_vault" "key_vault_core" {
#   name                = local.key_vault_core.name
#   resource_group_name = local.key_vault_core.resource_group_name
# }

# data "azurerm_key_vault" "key_vault_sensitive" {
#   name                = local.key_vault_sensitive.name
#   resource_group_name = local.key_vault_sensitive.resource_group_name
# }

# Resource Group data sources (created in day-1)
data "azurerm_resource_group" "core" {
  name = var.resource_group_core_name
}

data "azurerm_resource_group" "sensitive" {
  name = var.resource_group_sensitive_name
}

data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name_vnet
}

# Terraform Service Principal data source
data "azuread_service_principal" "terraform" {
  client_id = var.terraform_client_id != "" ? var.terraform_client_id : var.client_id
}

# Kubernetes cluster data source (created in day-1 or workloads)
# Note: This will fail if cluster doesn't exist, but that's expected during initial setup
data "azurerm_kubernetes_cluster" "cluster" {
  name                = local.cluster_name
  resource_group_name = var.resource_group_core_name
  depends_on          = [var.cluster_id] # Required for AGIC identity access. Note: This may cause role assignments to be recreated on plan, but is necessary for AGIC to function properly.
}

# Azure AD User data sources for role assignments
data "azuread_user" "cluster_admin" {
  for_each  = var.cluster_admins
  object_id = each.value
}

data "azuread_user" "main_keyvault_secret_writer" {
  for_each  = var.main_keyvault_secret_writers
  object_id = each.value
}

data "azuread_user" "telemetry_observer" {
  for_each  = var.telemetry_observers
  object_id = each.value
}

# Managed Identity data sources (from day-1)
data "azurerm_user_assigned_identity" "psql_identity" {
  name                = local.psql_user_assigned_identity_name
  resource_group_name = var.resource_group_sensitive_name
}

data "azurerm_user_assigned_identity" "ingestion_cache_identity" {
  name                = local.ingestion_cache_identity_name
  resource_group_name = var.resource_group_sensitive_name
}

data "azurerm_user_assigned_identity" "ingestion_storage_identity" {
  name                = local.ingestion_storage_identity_name
  resource_group_name = var.resource_group_sensitive_name
}

data "azurerm_user_assigned_identity" "aks_workload_identity" {
  name                = local.aks_user_assigned_identity_name
  resource_group_name = var.resource_group_core_name
}

data "azurerm_user_assigned_identity" "grafana_identity" {
  name                = local.grafana_identity_name
  resource_group_name = var.resource_group_core_name
}

# Custom Role Definition data sources (from day-1)
data "azurerm_role_definition" "acr_puller" {
  name  = "AcrPull Principals${local.env_suffix}"
  scope = data.azurerm_subscription.current.id
}

data "azurerm_role_definition" "vnet_subnet_access" {
  name  = "VNet Subnet Access (Preview) v2${local.env_suffix}"
  scope = data.azurerm_subscription.current.id
}

data "azurerm_role_definition" "telemetry_observer" {
  name  = "Telemetry Observer${local.env_suffix}"
  scope = data.azurerm_subscription.current.id
}

# # DNS Zone data source (created in day-1)
# data "azurerm_dns_zone" "dns_zone" {
#   name                = var.dns_zone.name
#   resource_group_name = var.dns_zone.resource_group_name
# }

