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
| <a name="module_linux_function_apps"></a> [linux\_function\_apps](#module\_linux\_function\_apps) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_function_app | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_function_app"></a> [function\_app](#input\_function\_app) | The Function App variable block. 'usecase' variable will determine the naming of the Function App | <pre>list(object({<br>    usecase = string<br>  }))</pre> | n/a | yes |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | The name of the virtual network to which the subnet belongs. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure location where the resources will be deployed. | `string` | `"West Europe"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the virtual network to which the subnet belongs. | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The name of the resource group where the virtual network is located. | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet within the virtual network where the storage account resides. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enables or Disables public access to the Function App. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the resources. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU (pricing tier) of the App Service Plan. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the Storage Account to be created or used. | `string` | n/a | yes |
| <a name="input_storage_account_resource_group_name"></a> [storage\_account\_resource\_group\_name](#input\_storage\_account\_resource\_group\_name) | The name of the resource group where the Storage Account is located. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_vnet_integration_subnet_name"></a> [vnet\_integration\_subnet\_name](#input\_vnet\_integration\_subnet\_name) | The ID of the subnet for Virtual Network Integration | `string` | n/a | yes |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | The number of Workers (instances) to be allocated. | `number` | `1` | no |
| <a name="input_zone_balancing_enabled"></a> [zone\_balancing\_enabled](#input\_zone\_balancing\_enabled) | Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created. | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->