<!-- BEGIN_TF_DOCS -->
# Storage Account with public endpoint

This deploys the Storage Account module with public endpoint.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.7)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)

- <a name="provider_random"></a> [random](#provider\_random)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [random_string.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_code_name"></a> [code\_name](#input\_code\_name)

Description: The code name for the product team

Type: `string`

Default: `""`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: The environment

Type: `string`

Default: `""`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resources.

Type: `string`

Default: `"norwayeast"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_azapi-module-storage-account"></a> [azapi-module-storage-account](#module\_azapi-module-storage-account)

Source: git::ssh://git@github.com/HafslundEcoVannkraft/stratus-terraform-modules.git//modules/storage_account

Version: main

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->