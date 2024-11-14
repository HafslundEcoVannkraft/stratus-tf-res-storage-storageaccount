locals {
  # Locals for getting subnet data
  vnet_rg_name = "${var.code_name}-network-rg-${var.environment}-${var.location}"
  vnet_name    = "${var.code_name}-vnet-${var.environment}-${var.location}"
  subnet_name  = "${var.code_name}-snet-${var.environment}-private-endpoints"

  # Locals for creating Key Vault 
  rg_name = "${var.code_name}-sa-rg-${var.environment}-${random_string.name_suffix.result}"
  sa_name = "${var.code_name}sa${var.environment}${random_string.name_suffix.result}"
}

# Getting subnet data for private endpoints
data "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_rg_name
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

# For this method to work with internal repo we might need to run this in GitHub Action. Testing in progress.
# git config --global url."https://${GITHUB_TOKEN}@github.com".insteadOf "https://github.com"

module "azapi-module-storage-account" {
  source               = "https://github.com/HafslundEcoVannkraft/stratus-tf-res-storage-storageaccount?ref=main"
  depends_on           = [azurerm_resource_group.rg]
  rg_name              = azurerm_resource_group.rg.name
  storage_account_name = local.sa_name
  location             = azurerm_resource_group.rg.location

  pe_subnets = [data.azurerm_subnet.subnet.id]
}

