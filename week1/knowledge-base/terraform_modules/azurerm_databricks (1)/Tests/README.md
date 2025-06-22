# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

## Notes

Any notes or comments for the Infra team can be added here. (Please add any notes or comments with a date DD/MM/YYYY)

## Terraform Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adb"></a> [adb](#module\_adb) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_databricks | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_frotend_private_access_enabled"></a> [frotend\_private\_access\_enabled](#input\_frotend\_private\_access\_enabled) | Should the front be private and access via Private Endpoint? | `bool` | `false` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault where the keys are stored | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the Static App will be created | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name) | The name of the private subnet | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name) | The name of the public subnet | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial. | `string` | `"standard"` | no |
| <a name="input_storage_account_sku_name"></a> [storage\_account\_sku\_name](#input\_storage\_account\_sku\_name) | Storage account SKU name. Possible values include Standard\_LRS, Standard\_GRS, Standard\_RAGRS, Standard\_GZRS, Standard\_RAGZRS, Standard\_ZRS, Premium\_LRS or Premium\_ZRS. Defaults to Standard\_GRS. | `string` | `"Standard_LRS"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umids_names"></a> [umids\_names](#input\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->