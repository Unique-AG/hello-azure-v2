terraform {
  required_version = ">= 1.17"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.11.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.2.0"
    }
  }
}
