# Backend Configuration Variables
variable "subscription_id" {
  description = "The UUID ID of the subscription (not the full Azure Resource ID)."
  type        = string
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

# Resource Locations
variable "resource_group_core_location" {
  description = "The location for core resource group"
  type        = string
}

variable "resource_vnet_location" {
  description = "The location for virtual network resources"
  type        = string
}

# Resource Group Names
variable "resource_group_core_name" {
  description = "The core resource group name"
  type        = string
}

variable "resource_group_name_vnet" {
  description = "Name of the resource group containing the VNET"
  type        = string
}

# Network Configuration
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

# Naming and Tagging
variable "name_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "ha"
}

variable "env" {
  description = "Environment name (e.g., dev, test or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# Bastion Configuration
variable "bastion_name" {
  description = "Name of the Azure Bastion host"
  type        = string
  default     = "bastion"
}

variable "bastion_sku" {
  description = "SKU for Azure Bastion (Standard or Basic)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Basic"], var.bastion_sku)
    error_message = "Bastion SKU must be either Standard or Basic."
  }
}

variable "bastion_tunneling_enabled" {
  description = "Enable tunneling for Azure Bastion (required for kubectl port forwarding)"
  type        = bool
  default     = true
}

variable "bastion_native_client_support_enabled" {
  description = "Enable native client support (IP Connect) for Azure Bastion"
  type        = bool
  default     = true
}

variable "bastion_public_ip_name" {
  description = "Name of the public IP for Azure Bastion"
  type        = string
  default     = "bastion-pip"
}

# Monitoring Configuration
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace (from day-1)"
  type        = string
}

