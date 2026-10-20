terraform {
  required_version = ">= 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.65" # user_assigned_identity_id on federated identity credentials
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }
}
