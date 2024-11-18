location    = "norwayeast"
code_name   = "oy004"
environment = "test"

# variable "rg_name" {
#   type = string
#   description = "Resource group name"
# }

# variable "storage_account_name" {
#   type = string
#   description = "Name of the storage account"
# }

# variable "location" {
#   type = string
#   description = "Location of the storage account. Defaults to resource group location."
#   default = ""
# }

# variable "online_config" {
#   type = object({
#     allowlisted_ip_addresses = list(string)
#     allowlisted_subnets = list(string)
#   })
#   description = "Allowlisted IP addresses and subnets"
#   default = {
#     allowlisted_ip_addresses = []
#     allowlisted_subnets = []
#   }
# }

# variable "blob_properties" {
#   type = object({
#     delete_retention_policy_days = number
#     container_delete_retention_policy_days = number
#   })
#   description = "Blob properties"
#   default = {
#     delete_retention_policy_days = 7
#     container_delete_retention_policy_days = 7
#   }
# }

# variable "cors_rules" {
#   type = list(object({
#     allowed_headers = list(string)
#     allowed_methods = list(string)
#     allowed_origins = list(string)
#     exposed_headers = list(string)
#     max_age_in_seconds = number
#   }))
#   description = "CORS rules"
#   default = []
# }

#rg_name              = "stratus-tf-e2e-test-storage-account"
#storage_account_name = "magnusdeletemesa16oct"
#location             = "norwayeast"
#pe_subnets           = ["/subscriptions/aed6d9ab-1e1b-4452-a1ad-551ae83ecc19/resourceGroups/cy004-network-rg-test-norwayeast/providers/Microsoft.Network/virtualNetworks/cy004-vnet-test-norwayeast/subnets/cy004-snet-test-private-endpoints"]
