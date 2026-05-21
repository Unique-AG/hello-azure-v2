# ACR pull credentials for Argo CD OCI Helm chart pulls from the tenant registry.
# Synced into the cluster via External Secrets (03_applications/test/values/argo/argo-repository-secrets.yaml).
# Pattern aligned with infrastructure/providers/azure/unique-ag/legacy/shared/42-acr-pull-kv.tf

resource "azurerm_container_registry_scope_map" "argocd_helm_pull" {
  name                    = "argocd-helm-pull"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = data.azurerm_resource_group.core.name
  description             = "Pull-only access for Argo CD OCI Helm charts (reflector, assistants-agentic-table)"
  actions = [
    "repositories/helm/reflector/content/read",
    "repositories/helm/reflector/metadata/read",
    "repositories/helm/assistants-agentic-table/content/read",
    "repositories/helm/assistants-agentic-table/metadata/read",
  ]
}

resource "azurerm_container_registry_token" "argocd_helm_pull" {
  name                    = "argocd-helm-pull"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = data.azurerm_resource_group.core.name
  scope_map_id            = azurerm_container_registry_scope_map.argocd_helm_pull.id
  enabled                 = true
}

resource "azurerm_container_registry_token_password" "argocd_helm_pull" {
  container_registry_token_id = azurerm_container_registry_token.argocd_helm_pull.id
  password1 {}
}

resource "azurerm_key_vault_secret" "uqhacrtest_argocd_helm_pull_username" {
  name         = "uqhacrtest-azurecr-io-username"
  value        = azurerm_container_registry_token.argocd_helm_pull.name
  key_vault_id = data.azurerm_key_vault.key_vault_sensitive.id
}

resource "azurerm_key_vault_secret" "uqhacrtest_argocd_helm_pull_password" {
  name         = "uqhacrtest-azurecr-io-password"
  value        = one(azurerm_container_registry_token_password.argocd_helm_pull.password1).value
  key_vault_id = data.azurerm_key_vault.key_vault_sensitive.id
}
