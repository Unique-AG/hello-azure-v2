terraform {
  required_version = ">= 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.39"
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
      version = "2.2.0"
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
