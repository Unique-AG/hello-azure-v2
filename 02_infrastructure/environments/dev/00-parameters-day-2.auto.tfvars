# Day-2 specific parameters

# Resource Group Names
resource_group_core_name      = "resource-group-core"
resource_group_sensitive_name = "resource-group-sensitive"
resource_group_name_vnet      = "rg-vnet-002"

# Key Vaults
key_vault_core = {
  name                = "helloazuremain"
  resource_group_name = "resource-group-core"
}

key_vault_sensitive = {
  name                = "helloazuresensitive"
  resource_group_name = "resource-group-sensitive"
}

# AKS Cluster
aks = {
  name                = "aks-dev"  # Matches computed pattern "aks-${var.env}" when env=dev
  resource_group_name = "resource-group-core"
}

# DNS Zone
dns_zone = {
  name                = "hello.azure.unique.dev"  # Override: doesn't follow "${var.env}-hello.azure.unique.dev" pattern
  resource_group_name = "resource-group-core"
}

# Application Registration
application_registration_gitops_display_name = "GitOps"
application_secret_display_name = "hello-azure-dev-gitops"

# User permissions
gitops_maintainer_user_ids = [
  "4ee4611f-b24c-444b-8d34-edab333bf868",
  "4b89a1f0-8038-4929-81e6-6d128dac7aa0",
  "084a1c45-5010-4aab-bab6-7b86a9d10e5c",
  "3b48f167-cb68-4655-b45b-878e170af84d",
  "45caeab6-e1dd-4f9a-aa0c-ea1fb6c0c5ff",
]

# Azure AD Groups
telemetry_observer_group_display_name        = "Telemetry Observer"
sensitive_data_observer_group_display_name   = "Sensitive Data Observer"
devops_group_display_name                    = "DevOps"
emergency_admin_group_display_name           = "Emergency Admin"
admin_kubernetes_cluster_group_display_name  = "Admin Kubernetes Cluster"
main_keyvault_secret_writer_group_display_name = "Main KeyVault writer"

# Federated Identity Credentials
cluster_workload_identities = {
  "backend-service-chat" = {
    name      = "backend-service-chat"
    namespace = "unique"
  }
  "backend-service-ingestion-worker-chat" = {
    name      = "backend-service-ingestion-worker-chat"
    namespace = "unique"
  }
  "backend-service-ingestion-worker" = {
    name      = "backend-service-ingestion-worker"
    namespace = "unique"
  }
  "backend-service-ingestion" = {
    name      = "backend-service-ingestion"
    namespace = "unique"
  }
  "assistants-core" = {
    name      = "assistants-core"
    namespace = "unique"
  }
  "backend-service-speech" = {
    name      = "backend-service-speech"
    namespace = "unique"
  }
}
