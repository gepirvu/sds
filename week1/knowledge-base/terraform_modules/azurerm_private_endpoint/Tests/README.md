# Infra Team Test 

This module is used to test the private endpoint module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_endpoint_kv"></a> [private\_endpoint\_kv](#module\_private\_endpoint\_kv) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_is_manual_connection"></a> [is\_manual\_connection](#input\_is\_manual\_connection) | Boolean flag to specify whether the connection should be manual. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_private_connection_resource_id"></a> [private\_connection\_resource\_id](#input\_private\_connection\_resource\_id) | The Resource ID which the private endpoint should be created for. | `string` | n/a | yes |
| <a name="input_private_dns_zone_group"></a> [private\_dns\_zone\_group](#input\_private\_dns\_zone\_group) | List of private dns zone groups to associate with the private endpoint. | <pre>list(object({<br/>    enabled              = bool<br/>    name                 = string<br/>    private_dns_zone_ids = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | The name of the Private Endpoint. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the private endpoint resource will be created. | `string` | n/a | yes |
| <a name="input_subresource_names"></a> [subresource\_names](#input\_subresource\_names) | A list of subresource names which the Private Endpoint is able to connect to. subresource\_names corresponds to group\_id. Changing this forces a new resource to be created. | `list(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->