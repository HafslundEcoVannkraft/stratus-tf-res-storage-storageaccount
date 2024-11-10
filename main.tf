data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

# # create storage account and KV for Azure AI Hub
# resource "azurerm_storage_account" "storage_account" {
#   name                            = var.storage_account_name
#   resource_group_name             = var.rg_name
#   location                        = var.location == "" ? data.azurerm_resource_group.rg.location : var.location
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   public_network_access_enabled   = true
#   allow_nested_items_to_be_public = false
#   account_kind                    = "StorageV2"
#   network_rules {
#     default_action             = var.online_config.allowlisted_ip_addresses == [] && var.online_config.allowlisted_subnets == [] ? "Allow" : "Deny"
#     ip_rules                   = var.online_config.allowlisted_ip_addresses
#     virtual_network_subnet_ids = var.online_config.allowlisted_subnets
#   }
#   allowed_copy_scope               = "AAD"
#   cross_tenant_replication_enabled = false
#   shared_access_key_enabled        = false
#   min_tls_version                  = "TLS1_2"
#   blob_properties {
#     delete_retention_policy {
#       days = var.blob_properties.delete_retention_policy_days
#     }
#     versioning_enabled  = false
#     change_feed_enabled = false
#     container_delete_retention_policy {
#       days = var.blob_properties.container_delete_retention_policy_days
#     }
#     dynamic "cors_rule" {
#       for_each = length(var.cors_rules) > 0 ? var.cors_rules : []

#       content {
#         allowed_headers    = cors_rule.value.allowed_headers
#         allowed_methods    = cors_rule.value.allowed_methods
#         allowed_origins    = cors_rule.value.allowed_origins
#         exposed_headers    = cors_rule.value.exposed_headers
#         max_age_in_seconds = cors_rule.value.max_age_in_seconds
#       }
#     }
#     # cors_rules = [
#     # {
#     #   allowed_headers    = ["*"]
#     #   allowed_methods    = ["GET", "POST", "OPTIONS"]
#     #   allowed_origins    = ["*"]
#     #   exposed_headers    = ["*"]
#     #   max_age_in_seconds = 3600
#     #     }
#     # ]
#   }
#   queue_encryption_key_type         = "Account"
#   table_encryption_key_type         = "Account"
#   infrastructure_encryption_enabled = true
#   # encryption = {
#   #   require_infrastructure_encryption = true
#   #   services = {
#   #     blob = {
#   #       require_infrastructure_encryption = true
#   #       key_type = "Account"
#   #     }
#   #     file = {
#   #       require_infrastructure_encryption = true
#   #       key_type = "Account"
#   #     }
#   #     queue = {
#   #       require_infrastructure_encryption = true
#   #       key_type = "Account"
#   #     }
#   #     table = {
#   #       require_infrastructure_encryption = true
#   #       key_type = "Service"
#   #     }
#   #   }
#   # }
# }

locals {
  data_protection = {
    change_feed_enabled                    = true
    change_feed_retention_in_days          = 30
    versioning_enabled                     = true
    restore_policy_days                    = 14
    container_delete_retention_policy_days = 30
    delete_retention_policy_days           = 15
  }
  pe_subnets_map = {
    for subnet_id in var.pe_subnets : subnet_id => {
      subnet_id           = subnet_id
      subnet_name         = split("/", subnet_id)[10]
      vnet_name           = split("/", subnet_id)[8]
      resource_group_name = split("/", subnet_id)[4]
    }
  }
}

# Data source to fetch subnet details
data "azurerm_virtual_network" "vnets" {
  for_each            = local.pe_subnets_map
  name                = each.value.vnet_name
  resource_group_name = each.value.resource_group_name
}

resource "azapi_resource" "storage_account_v2" {
  type      = "Microsoft.Storage/storageAccounts@2023-01-01"
  name      = var.storage_account_name
  parent_id = data.azurerm_resource_group.rg.id
  location  = var.location
  body = {
    properties = {
      # if length of var.pe_subnets is 0 then we will not create a private endpoint
      publicNetworkAccess         = length(var.pe_subnets) > 0 ? "Disabled" : "Enabled"
      allowedCopyScope            = "AAD"
      allowCrossTenantReplication = false
      allowBlobPublicAccess       = false
      allowSharedKeyAccess        = false
      minimumTlsVersion           = "TLS1_2"
      encryption = {
        requireInfrastructureEncryption = true
        services = {
          blob = {
            keyType = "Account"
            enabled = true
          }
          queue = {
            keyType = "Account"
            enabled = true
          }
          file = {
            keyType = "Account"
            enabled = true
          }
          table = {
            keyType = "Account"
            enabled = true
          }
        }
      }
      networkAcls = {
        defaultAction = "Deny"
        bypass        = "None"
        #virtualNetworkRules = local.virtual_network_rules
      }
    }
    sku = {
      name = "Standard_LRS"
    }
    kind = "StorageV2"
  }
  #tags                      = var.tags
  response_export_values    = ["*"]
  schema_validation_enabled = false
}

resource "azapi_update_resource" "storage_account_blob_service_v2" {
  type      = "Microsoft.Storage/storageAccounts/blobServices@2023-01-01"
  name      = "default"
  parent_id = azapi_resource.storage_account_v2.id
  body = {
    properties = {
      changeFeed = {
        enabled         = local.data_protection["change_feed_enabled"]
        retentionInDays = local.data_protection["change_feed_retention_in_days"]
      }
      isVersioningEnabled = local.data_protection["versioning_enabled"]
      restorePolicy = {
        enabled = true
        days    = local.data_protection["restore_policy_days"]
      }
      containerDeleteRetentionPolicy = {
        enabled = true
        days    = local.data_protection["container_delete_retention_policy_days"]
      }
      deleteRetentionPolicy = {
        enabled = true
        days    = local.data_protection["delete_retention_policy_days"]
      }
    }
  }
  response_export_values = ["*"]
  depends_on             = [azapi_resource.storage_account_v2]
}

resource "azapi_resource" "private_endpoint_v2" {
  for_each  = local.pe_subnets_map
  type      = "Microsoft.Network/privateEndpoints@2023-04-01"
  name      = "${var.storage_account_name}-pe-${data.azurerm_virtual_network.vnets[each.value.subnet_id].location}-${each.value.subnet_name}"
  parent_id = data.azurerm_resource_group.rg.id
  location  = data.azurerm_virtual_network.vnets[each.value.subnet_id].location
  body = {
    properties = {
      subnet = {
        id = each.value.subnet_id
      }
      privateLinkServiceConnections = [
        {
          name = "blob"
          properties = {
            privateLinkServiceId = azapi_resource.storage_account_v2.id
            groupIds             = ["blob"]
          }
        }
      ]
    }
  }
  response_export_values    = ["*"]
  schema_validation_enabled = false
  depends_on                = [data.azurerm_resource_group.rg, azapi_resource.storage_account_v2]
  #ignore_body_changes       = ["properties.private_dns_zone_group"]
  lifecycle {
    ignore_changes = [body.properties.private_dns_zone_group]
  }
}

# Time wait for Private DNS Zone Configuration to be completed
# Experimental, we need to check if 90s is enough for the Azure Policy to pickup and apply the Private DNS Zone configuration, otherwise we need to increase the time.
resource "time_sleep" "wait_for_private_dns_zone_policy_v2" {
  count           = length(var.pe_subnets) > 0 ? 1 : 0
  depends_on      = [azapi_resource.private_endpoint_v2]
  create_duration = "90s"
}

resource "azapi_resource" "container_v2" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01"
  name      = "tfstate"
  parent_id = "${azapi_resource.storage_account_v2.id}/blobServices/default"
  body = {
    properties = {
      publicAccess                = "None"
      denyEncryptionScopeOverride = false
      defaultEncryptionScope      = "$account-encryption-key"
    }
  }
  # Adding Timeouts to the resource to avoid timeouts during the creation of the storage container, as we need to wait for the Private DNS Zone Policy to be applied.
  timeouts {
    create = "10m"
  }
  response_export_values    = ["*"]
  schema_validation_enabled = false
  depends_on                = [time_sleep.wait_for_private_dns_zone_policy_v2]
}