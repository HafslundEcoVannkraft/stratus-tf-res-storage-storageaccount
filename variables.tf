variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "location" {
  type        = string
  description = "Location of the storage account. Defaults to resource group location."
  default     = ""
}

variable "pe_subnets" {
  type        = list(string)
  description = "List of subnets to create private endpoints for"
}