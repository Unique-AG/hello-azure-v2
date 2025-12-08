resource "azuread_app_role_assignment" "read_users" {
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
  principal_object_id = azuread_service_principal.terraform.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "read_write_groups" {
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
  principal_object_id = azuread_service_principal.terraform.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "read_write_role_management" {
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["RoleManagement.ReadWrite.Directory"]
  principal_object_id = azuread_service_principal.terraform.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "read_write_application" {
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
  principal_object_id = azuread_service_principal.terraform.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
