# Application Registration for GitOps
# This creates an Azure AD application registration for GitOps authentication

locals {
  maintainers_principal_object_ids = [for user in values(data.azuread_user.gitops_maintainer) : user.object_id]
}

# Reference the existing Microsoft Graph service principal (well-known Azure AD app)
# This is a shared resource that already exists - we only need to reference it
data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

module "application_registration" {
  source = "github.com/Unique-AG/terraform-modules.git//modules/azure-entra-app-registration-argocd?ref=c41d30f097c181d953a1ce8775774116d0d90797" # azure-entra-app-registration-argocd-1.0.0
  # The old generic module (azure-entra-app-registration 4.0.0) granted no consent, and the Terraform
  # identity lacks DelegatedPermissionGrant.ReadWrite.All.
  admin_consent_enabled     = false
  display_name              = var.application_registration_gitops_display_name
  role_assignments_required = false
  client_secret_generation_config = {
    enabled     = true
    keyvault_id = data.azurerm_key_vault.key_vault_sensitive.id
    secret_name = local.application_secret_display_name
    # Keep the 4.0.0 names: Argo CD reads these two Key Vault secrets, and changing the
    # password display name would recreate the password.
    explicit_client_id_secret_name     = "aad-app-${local.application_secret_display_name}-client-id"
    explicit_client_secret_secret_name = "aad-app-${local.application_secret_display_name}-client-secret"
    explicit_password_display_name     = "unique-enterprise-gitops-app-key"
  }
  redirect_uris = [
    "https://argo.${data.azurerm_dns_zone.dns_zone.name}/auth/callback",
  ]
  required_resource_access_list = {
    (data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph) = [
      {
        id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["profile"]
        type = "Scope"
      },
      {
        id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
        type = "Scope"
      },
      {
        id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["openid"]
        type = "Scope"
      },
      {
        id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["email"]
        type = "Scope"
      },
    ],
  }
  application_support_object_ids = local.maintainers_principal_object_ids
}

