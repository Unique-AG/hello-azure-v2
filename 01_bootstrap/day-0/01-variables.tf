variable "subscription_id" {
  description = "The UUID ID of the subscription"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, test or prod)"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name for the tfstate"
  type        = string
  default     = "rg-terraform-state"
}

variable "storage_account_name" {
  description = "The storage account name for the tfstate"
  type        = string
}

variable "container_name" {
  description = "The container name for the tfstate"
  type        = string
}

variable "key" {
  description = "The key for the tfstate"
  type        = string
  default     = "terraform-init"
}

variable "tfstate_location" {
  description = "The location for the tfstate resources"
  type        = string
  default     = "switzerlandnorth"
}

variable "tenant_id" {
  description = "The ID of the tenant"
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
