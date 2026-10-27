terraform {
  required_version = ">= 1.17"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.11.0"
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
      version = "2.13.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.2"
    }
  }
}
