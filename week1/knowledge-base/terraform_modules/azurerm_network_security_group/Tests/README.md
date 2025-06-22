# Infra Team Test

This module is for testing purposes only.


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
| <a name="module_axso_nsg"></a> [axso\_nsg](#module\_axso\_nsg) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_network_security_group | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | value for the location where the NSG should be created | `string` | `"westeurope"` | no |
| <a name="input_nsgs"></a> [nsgs](#input\_nsgs) | Specifies a list of objects to represent Network Security Group(NSG) rules | <pre>list(object({<br/>    subnet_name         = string<br/>    associate_to_subnet = bool<br/><br/><br/>    nsg_rules = list(object({<br/>      nsg_rule_name                = optional(string, "default_rule_name")<br/>      priority                     = optional(string, "101")<br/>      direction                    = optional(string, "Any")<br/>      access                       = optional(string, "Allow")<br/>      protocol                     = optional(string, "*")<br/>      source_port_range            = optional(string, null)<br/>      source_port_ranges           = optional(list(string), null)<br/>      destination_port_range       = optional(string, null)<br/>      destination_port_ranges      = optional(list(string), null)<br/>      source_address_prefix        = optional(string, null)<br/>      source_address_prefixes      = optional(list(string), null)<br/>      destination_address_prefix   = optional(string, null)<br/>      destination_address_prefixes = optional(list(string), null)<br/>  })) }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | value for the resource group name where the NSG should be created (normally the network resource group) | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->