terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.2.0"
    }
  }
}
