# Infra Team Test

This module is used for testing purposes only.

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
| <a name="module_axso_rt"></a> [axso\_rt](#module\_axso\_rt) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_route_table | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp_route_propagation_enabled"></a> [bgp\_route\_propagation\_enabled](#input\_bgp\_route\_propagation\_enabled) | Boolean flag which controls propagation of routes learned by BGP on that route table. | `bool` | `false` | no |
| <a name="input_default_hub_route"></a> [default\_hub\_route](#input\_default\_hub\_route) | Boolean flag which controls the creation of the default route table. True means create. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name of the environment e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location to create the UDR table e.g westeurope | `string` | `"westeurope"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to place the UDR in (normally core network resource group) | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |
| <a name="input_udr_config"></a> [udr\_config](#input\_udr\_config) | The configuration of the UDR routes | <pre>object({<br/>    routes = list(object({<br/>      route_name     = string<br/>      address_prefix = string<br/>      next_hop_type  = string<br/>      next_hop_ip    = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "routes": [<br/>    {<br/>      "address_prefix": "10.217.0.0/16",<br/>      "next_hop_ip": null,<br/>      "next_hop_type": "VirtualAppliance",<br/>      "route_name": "test-route1"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_usecase"></a> [usecase](#input\_usecase) | The usecase of the route table to use in the route table name | `string` | `"psql"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->