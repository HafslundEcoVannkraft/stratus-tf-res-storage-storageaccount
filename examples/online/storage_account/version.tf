provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
}


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
  required_version = ">= 1.9.7"
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }
}
 