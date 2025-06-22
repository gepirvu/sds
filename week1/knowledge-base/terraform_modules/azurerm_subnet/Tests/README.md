# Infra Team Test

This template is only used for testing purposes.

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
| <a name="module_subnet"></a> [subnet](#module\_subnet) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_subnet | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The default location where the core network will be created | `string` | n/a | yes |
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | List of subnet configurations. | <pre>list(object({<br>    subnet_name                                   = string<br>    subnet_address_prefixes                       = list(string)<br>    default_name_network_security_group_create    = optional(bool)<br>    custom_name_network_security_group            = optional(string)<br>    route_table_name                              = optional(string)<br>    private_endpoint_network_policies_enabled     = optional(string)<br>    private_link_service_network_policies_enabled = optional(bool)<br>    subnet_service_endpoints                      = optional(list(string))<br>    subnets_delegation_settings = optional(map(list(object({<br>      name    = string<br>      actions = list(string)<br>    }))))<br>  }))</pre> | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet, used to identify its purpose. | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group that contains the NSG and the Route table | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->