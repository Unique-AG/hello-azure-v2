variable "subscription_id" {
  description = "The UUID ID of the subscription"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, test or prod)"
  type        = string

  validation {
    condition     = var.env != "" && (var.env == "dev" || var.env == "test" || var.env == "prod")
    error_message = "The env variable must be either 'dev' or 'test' or 'prod' and cannot be empty."
  }
}

variable "resource_group_name" {
  description = "The resource group name for the tfstate"
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "The storage account name for the tfstate"
  type        = string
}

variable "container_name" {
  description = "The container name for the tfstate"
  type        = string
  default     = "tfstate"
}

variable "key" {
  description = "The key for the tfstate"
  type        = string
  default     = null
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
