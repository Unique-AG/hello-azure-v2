# Kubernetes Cluster (AKS)
# This module creates an Azure Kubernetes Service cluster with node pools and monitoring

module "kubernetes_cluster" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-kubernetes-service?ref=azure-kubernetes-service-4.0.1"

  kubernetes_version                      = var.kubernetes_version
  application_gateway_id                  = data.azurerm_application_gateway.application_gateway.id
  segregated_node_and_pod_subnets_enabled = true
  cluster_name                            = local.cluster_name
  kubernetes_default_node_size            = var.kubernetes_default_node_size
  kubernetes_default_node_zones           = ["1", "3"]
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
    enabled                = true
    grafana_major_version  = "11"
    identity = {
      type         = "UserAssigned"
      identity_ids = [data.azurerm_user_assigned_identity.grafana_identity.id]
    }
  }

  network_profile = {
    idle_timeout_in_minutes = 100
    outbound_ip_address_ids = [data.azurerm_public_ip.aks_public_ip.id]
  }

  node_pool_settings = {
    rapid = {
      auto_scaling_enabled = true
      max_count            = var.kubernetes_rapid_max_count
      min_count            = var.kubernetes_rapid_min_count
      mode                 = "User"
      node_count           = var.kubernetes_rapid_node_count
      node_labels = {
        lifecycle   = "ephemeral"
        scalability = "rapid"
      }
      node_taints     = ["scalability=rapid:NoSchedule", "lifecycle=ephemeral:NoSchedule"]
      os_disk_size_gb = 100
      os_sku          = "AzureLinux"
      upgrade_settings = {
        max_surge = "10%"
      }
      vm_size = var.kubernetes_rapid_node_size
      zones   = ["1", "3"]
    }
    steady = {
      auto_scaling_enabled = true
      max_count            = var.kubernetes_steady_max_count
      min_count            = var.kubernetes_steady_min_count
      mode                 = "User"
      node_count           = var.kubernetes_steady_node_count
      node_labels = {
        lifecycle   = "persistent"
        scalability = "steady"
      }
      node_taints     = []
      os_disk_size_gb = 100
      os_sku          = "AzureLinux"
      upgrade_settings = {
        max_surge = "30%"
      }
      vm_size = var.kubernetes_steady_node_size
      zones   = ["1", "3"]
    }
  }
}

