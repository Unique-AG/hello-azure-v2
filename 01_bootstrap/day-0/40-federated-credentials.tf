# resource "azuread_application_federated_identity_credential" "github_actions_terraform_main" {
#   application_id = azuread_application_registration.terraform.id
#   display_name   = "github-actions-terraform-main"
#   description    = "GH actions deploying Azure resources for the `main` branch of hello-azure"
#   audiences      = ["api://AzureADTokenExchange"]
#   issuer         = "https://token.actions.githubusercontent.com"
#   subject        = "repo:Unique-AG/hello-azure:ref:refs/heads/main"
# }
resource "azuread_application_federated_identity_credential" "github_actions_terraform_env" {
  for_each       = toset(["00-init", "10-pm", "20-wl"])
  application_id = azuread_application_registration.terraform.id
  display_name   = "github-actions-terraform-env-${each.value}"
  description    = "GH actions deploying Azure resources for the `${each.value}` env of hello-azure"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:Unique-AG/hello-azure:environment:${each.value}"
}

# resource "azuread_application_federated_identity_credential" "github_actions_terraform_dev" {
#   application_id = azuread_application_registration.terraform.id
#   display_name   = "github-actions-terraform-dev"
#   description    = "GH actions deploying Azure resources for the `dev` branch of hello-azure"
#   audiences      = ["api://AzureADTokenExchange"]
#   issuer         = "https://token.actions.githubusercontent.com"
#   subject        = "repo:Unique-AG/hello-azure:ref:refs/heads/dev"
# }
