resource "azuread_service_principal" "terraform" {
  client_id                    = azuread_application_registration.terraform.client_id
  app_role_assignment_required = false
}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}
