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

variable "container_names" {
  type        = list(string)
  description = "List of names for containers to create"
  default     = []
}

variable "network_acls_bypass" {
  type = string
  description = "The network ACLs bypass value. Possible values are `AzureServices`, `None`, and `VirtualNetwork`."
  default = "None"
}