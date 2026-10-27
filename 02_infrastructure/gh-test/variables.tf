variable "resource_group_vnet_name" {
  description = "The resource group of the virtual network that holds the runner subnet."
  type        = string
}
variable "tags" {
  description = "Tags applied to the created resources."
  type        = map(string)
}
variable "vnet_name" {
  description = "The virtual network that holds the runner subnet."
  type        = string
}
variable "subnet_name" {
  description = "The subnet delegated to GitHub-hosted runners."
  type        = string
}
variable "github_org_id" {
  description = "The GitHub organization database ID (numeric). Find it using: gh api orgs/{org} --jq .id"
  type        = number
}
variable "subscription_id" {
  description = "The UUID ID of the suscription (not the full Azure Resource ID)."
  type        = string
}
variable "resource_group_name" {
  description = "The resource group name for the tfstate."
  type        = string
}
variable "storage_account_name" {
  description = "The resource group name for the storage account name"
  type        = string
}
variable "container_name" {
  description = "The resource group name for the tfstate container name"
  type        = string
}
variable "key" {
  description = "The key for the tfstate"
  type        = string
}
variable "tenant_id" {
  description = "The ID of the tenenat"
  type        = string
}
variable "client_id" {
  description = "The client ID for OIDC"
  type        = string
}
variable "use_oidc" {
  description = "Whether to use OIDC"
  type        = bool
}
