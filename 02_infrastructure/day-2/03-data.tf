# Data sources for referencing existing Azure resources
data "azurerm_subscription" "current" {}

# Role definitions for custom roles
data "azurerm_role_definition" "contributor" {
  name = local.contributor_role_name
}

data "azurerm_role_definition" "reader" {
  name = local.reader_role_name
}

data "azurerm_role_definition" "acr_pull" {
  name = local.acr_pull_role_name
}

# Azure AD data sources
data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_user" "gitops_maintainer" {
  for_each  = toset(var.gitops_maintainer_user_ids)
  object_id = each.value
}

// Key Vault data sources (created in day-1)
data "azurerm_key_vault" "key_vault_core" {
  name                = local.key_vault_core.name
  resource_group_name = local.key_vault_core.resource_group_name
}

data "azurerm_key_vault" "key_vault_sensitive" {
  name                = local.key_vault_sensitive.name
  resource_group_name = local.key_vault_sensitive.resource_group_name
}

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

# Managed Identity data sources (created in day-1)
data "azurerm_user_assigned_identity" "psql_identity" {
  name                = local.psql_user_assigned_identity_name
  resource_group_name = data.azurerm_resource_group.sensitive.name
}

data "azurerm_user_assigned_identity" "ingestion_cache_identity" {
  name                = local.ingestion_cache_identity_name
  resource_group_name = data.azurerm_resource_group.sensitive.name
}

data "azurerm_user_assigned_identity" "ingestion_storage_identity" {
  name                = local.ingestion_storage_identity_name
  resource_group_name = data.azurerm_resource_group.sensitive.name
}

data "azurerm_user_assigned_identity" "aks_workload_identity" {
  name                = local.aks_user_assigned_identity_name
  resource_group_name = data.azurerm_resource_group.core.name
}

data "azurerm_user_assigned_identity" "grafana_identity" {
  name                = local.grafana_identity_name
  resource_group_name = data.azurerm_resource_group.core.name
}

# Custom Role Definition data sources (created in day-1)
data "azurerm_role_definition" "acr_puller" {
  name  = local.acr_pull_principals_role_name
  scope = data.azurerm_subscription.current.id
}

data "azurerm_role_definition" "vnet_subnet_access" {
  name  = local.vnet_subnet_access_role_name
  scope = data.azurerm_subscription.current.id
}

data "azurerm_role_definition" "telemetry_observer" {
  name  = local.telemetry_observer_role_name
  scope = data.azurerm_subscription.current.id
}

# DNS Zone data source (created in day-1)
# Note: DNS zone name in day-1 uses var.dns_zone_name directly (without env suffix)
data "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name_vnet
}

# Azure AD Service Principal for Terraform
# The terraform service principal is created in day-0/bootstrap
# To find the correct object_id, run: az ad sp list --display-name "terraform" --query "[].{objectId:id,displayName:displayName}" -o table
data "azuread_service_principal" "terraform" {
  object_id = var.terraform_service_principal_object_id
}

# Azure AD Users
data "azuread_user" "cluster_admin" {
  for_each  = toset(var.cluster_admin_user_ids)
  object_id = each.value
}

data "azuread_user" "main_keyvault_secret_writer" {
  for_each  = toset(var.keyvault_secret_writer_user_ids)
  object_id = each.value
}

data "azuread_user" "telemetry_observer" {
  for_each  = toset(var.telemetry_observer_user_ids)
  object_id = each.value
}

# Kubernetes Cluster data source (will be created in day-2, but referenced here)
# Note: This may not exist during initial import, so role assignments that depend on it
# should be imported after the cluster is created
# COMMENTED OUT - AKS cluster related imports are disabled
# data "azurerm_kubernetes_cluster" "cluster" {
#   name                = local.aks.name
#   resource_group_name = local.aks.resource_group_name
# }

# Log Analytics Workspace data source (created in day-1)
data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.core.name
}

# Subnet data source for Application Gateway (created in day-1)
data "azurerm_subnet" "application_gateway" {
  name                 = "snet-application-gateway"
  virtual_network_name = "vnet-001"
  resource_group_name  = data.azurerm_resource_group.vnet.name
}

# AKS Subnet data sources (created in day-1)
data "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  virtual_network_name = "vnet-001"
  resource_group_name  = data.azurerm_resource_group.vnet.name
}

data "azurerm_subnet" "aks_pods" {
  name                 = "snet-aks-pods"
  virtual_network_name = "vnet-001"
  resource_group_name  = data.azurerm_resource_group.vnet.name
}

# Application Gateway data source (created in day-2, referenced here for role assignments)
data "azurerm_application_gateway" "application_gateway" {
  name                = local.application_gateway_name
  resource_group_name = data.azurerm_resource_group.core.name
}


# Application Gateway Public IP data source (created in day-2, referenced here for role assignments)
data "azurerm_public_ip" "application_gateway_public_ip" {
  name                = var.ip_name
  resource_group_name = data.azurerm_resource_group.core.name
}

# AKS Public IP data source (created in day-1)
data "azurerm_public_ip" "aks_public_ip" {
  name                = var.aks_public_ip_name
  resource_group_name = data.azurerm_resource_group.core.name
}

# AKS data source (created in day-2, referenced here for role assignments)
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.cluster_name
  resource_group_name = local.aks.resource_group_name
}
