resource "azurerm_role_assignment" "terraform_owner" {
  principal_id         = azuread_service_principal.terraform.object_id
  role_definition_name = "Owner"
  scope                = data.azurerm_subscription.this.id
}

resource "azurerm_role_assignment" "terraform_user_access_admin" {
  principal_id         = azuread_service_principal.terraform.object_id
  role_definition_name = "User Access Administrator"
  scope                = data.azurerm_subscription.this.id
}
