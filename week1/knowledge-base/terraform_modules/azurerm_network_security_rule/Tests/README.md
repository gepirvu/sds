# Infra Team Test

This template deploys Azure Network Security Rules and is linked with ADO pipelines in `TIM-INFRA-MODULES` for development testing.

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
| <a name="module_axso_nsg_rules"></a> [axso\_nsg\_rules](#module\_axso\_nsg\_rules) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_network_security_rule | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group will be created. | `string` | `"westeurope"` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | List of network security groups to apply rules to. | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the Resource Group that contains Network Security Groups(NSGs) to be configured/administered | `string` | `"rg-where-nsgs-are-located"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->