locals {
  # Locals for creating Key Vault 
  rg_name = "${var.code_name}-sa-rg-${var.environment}-${random_string.name_suffix.result}"
  sa_name = "${var.code_name}sa${var.environment}${random_string.name_suffix.result}"
}

# Getting tenant id for creating Key vault
data "azurerm_client_config" "current" {}

# Creating a randomizes suffix for the Key vault name
resource "random_string" "name_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

# Creating a resource group (Not required if a resource group already exists)
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = local.rg_name
  tags = {
    stratus_verified_example = "" # Replace or delete this tag
  }
}

module "azapi-module-storage-account" {
  source               = "github.com/HafslundEcoVannkraft/stratus-terraform-modules.git//modules/storage_account?ref=v0.1.0"
  depends_on           = [azurerm_resource_group.rg]
  rg_name              = azurerm_resource_group.rg.name
  storage_account_name = local.sa_name
  location             = azurerm_resource_group.rg.location

  pe_subnets = []
}
