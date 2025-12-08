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
    rapid = {
      auto_scaling_enabled = var.kubernetes_node_pool_settings_rapid_autoscaling_enabled
      max_count            = var.kubernetes_rapid_max_count
      min_count            = var.kubernetes_rapid_min_count
      mode                 = var.kubernetes_node_pool_settings_rapid_mode
      node_count           = var.kubernetes_rapid_node_count
      node_labels = {
        lifecycle   = var.kubernetes_node_pool_settings_rapid_node_labels.lifecycle
        scalability = var.kubernetes_node_pool_settings_rapid_node_labels.scalability
      }
      node_taints     = var.kubernetes_node_pool_settings_rapid_node_taints
      os_disk_size_gb = var.kubernetes_node_pool_settings_rapid_os_disk_size_gb
      os_sku          = var.kubernetes_node_pool_settings_rapid_os_sku
      upgrade_settings = {
        max_surge = var.kubernetes_node_pool_settings_rapid_upgrade_settings.max_surge
      }
      vm_size = var.kubernetes_rapid_node_size
      zones   = var.kubernetes_node_pool_settings_rapid_zones
    }
    steady = {
      auto_scaling_enabled = var.kubernetes_node_pool_settings_steady_autoscaling_enabled
      max_count            = var.kubernetes_steady_max_count
      min_count            = var.kubernetes_steady_min_count
      mode                 = var.kubernetes_node_pool_settings_steady_mode
      node_count           = var.kubernetes_steady_node_count
      node_labels = {
        lifecycle   = var.kubernetes_node_pool_settings_steady_node_labels.lifecycle
        scalability = var.kubernetes_node_pool_settings_steady_node_labels.scalability
      }
      node_taints     = var.kubernetes_node_pool_settings_steady_node_taints
      os_disk_size_gb = var.kubernetes_node_pool_settings_steady_os_disk_size_gb
      os_sku          = var.kubernetes_node_pool_settings_steady_os_sku
      upgrade_settings = {
        max_surge = var.kubernetes_node_pool_settings_steady_upgrade_settings.max_surge
      }
      vm_size = var.kubernetes_steady_node_size
      zones   = var.kubernetes_node_pool_settings_steady_zones
    }
  }
}

