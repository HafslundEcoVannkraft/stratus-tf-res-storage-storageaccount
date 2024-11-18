<!-- BEGIN_TF_DOCS -->
# Stratus Terraform Verified Module Storage Account Module

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>2.0.0)

## Resources

The following resources are used by this module:

- [azapi_resource.container_v2](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.private_endpoint_v2](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.storage_account_v2](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_update_resource.storage_account_blob_service_v2](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource) (resource)
- [time_sleep.wait_for_private_dns_zone_policy_v2](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [azurerm_virtual_network.vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_pe_subnets"></a> [pe\_subnets](#input\_pe\_subnets)

Description: List of subnets to create private endpoints for

Type: `list(string)`

### <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name)

Description: Resource group name

Type: `string`

### <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name)

Description: Name of the storage account

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_container_names"></a> [container\_names](#input\_container\_names)

Description: List of names for containers to create

Type: `list(string)`

Default: `[]`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the storage account. Defaults to resource group location.

Type: `string`

Default: `""`

### <a name="input_network_acls_bypass"></a> [network\_acls\_bypass](#input\_network\_acls\_bypass)

Description: The network ACLs bypass value. Possible values are `AzureServices`, `None`, and `VirtualNetwork`.

Type: `string`

Default: `"None"`

## Outputs

The following outputs are exported:

### <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name)

Description: n/a

### <a name="output_storage_account_resource_id"></a> [storage\_account\_resource\_id](#output\_storage\_account\_resource\_id)

Description: n/a

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
<!-- END_TF_DOCS -->