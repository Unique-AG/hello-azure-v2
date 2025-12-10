# Kubernetes Cluster (AKS)
# This module creates an Azure Kubernetes Service cluster with node pools and monitoring

module "kubernetes_cluster" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-kubernetes-service?ref=azure-kubernetes-service-4.0.1"

  kubernetes_version                      = var.kubernetes_version
  application_gateway_id                  = data.azurerm_application_gateway.application_gateway.id
  segregated_node_and_pod_subnets_enabled = var.aks_segregated_node_and_pod_subnets_enabled
  cluster_name                            = local.cluster_name
  kubernetes_default_node_size            = var.kubernetes_default_node_size
  kubernetes_default_node_zones           = var.kubernetes_default_node_zones
  node_rg_name                            = var.node_resource_group_name
  resource_group_location                 = data.azurerm_resource_group.core.location
  resource_group_name                     = data.azurerm_resource_group.core.name
  default_subnet_nodes_id                 = data.azurerm_subnet.aks_nodes.id
  default_subnet_pods_id                  = data.azurerm_subnet.aks_pods.id
  tags                                    = var.tags
  tenant_id                               = data.azurerm_client_config.current.tenant_id
  defender_log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.log_analytics.id
  prometheus_node_recording_rules         = var.prometheus_node_recording_rules
  prometheus_kubernetes_recording_rules   = var.prometheus_kubernetes_recording_rules
  prometheus_ux_recording_rules           = var.prometheus_ux_recording_rules

  log_analytics_workspace = {
    id                  = data.azurerm_log_analytics_workspace.log_analytics.id
    location            = data.azurerm_resource_group.core.location
    resource_group_name = data.azurerm_resource_group.core.name
  }

  azure_prometheus_grafana_monitor = {
    azure_monitor_location = data.azurerm_resource_group.core.location
    azure_monitor_rg_name  = data.azurerm_resource_group.core.name
    enabled                = var.grafana_monitor_enabled
    grafana_major_version  = var.grafana_major_version
    identity = {
      type         = var.grafana_identity_type
      identity_ids = [data.azurerm_user_assigned_identity.grafana_identity.id]
    }
  }

  network_profile = {
    idle_timeout_in_minutes = var.aks_network_profile_idle_timeout_in_minutes
    outbound_ip_address_ids = [data.azurerm_public_ip.aks_public_ip.id]
  }

  node_pool_settings = {
    for k, v in var.kubernetes_node_pool_settings : k => {
      temporary_name_for_rotation = "${k}repl"
      auto_scaling_enabled        = v.auto_scaling_enabled
      max_count                   = v.max_count
      min_count                   = v.min_count
      mode                        = v.mode
      node_count                  = v.node_count
      node_labels                 = v.node_labels
      node_taints                 = v.node_taints
      os_disk_size_gb             = v.os_disk_size_gb
      os_sku                      = v.os_sku
      upgrade_settings            = v.upgrade_settings
      vm_size                     = v.vm_size
      zones                       = v.zones
    }
  }
}

