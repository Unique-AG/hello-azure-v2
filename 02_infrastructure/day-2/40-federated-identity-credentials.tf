resource "azurerm_federated_identity_credential" "afic_workloads" {
  for_each            = var.cluster_workload_identities
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.core.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.kubernetes_cluster.cluster_resource.oidc_issuer_url
  parent_id           = data.azurerm_user_assigned_identity.aks_workload_identity.id
  subject             = "system:serviceaccount:${each.value.namespace}:${each.value.name}"
  depends_on = [
    data.azurerm_user_assigned_identity.aks_workload_identity,
    module.kubernetes_cluster.kubernetes_cluster_id
  ]
}
