# Infra Team Test

This test template deploys an Azure resource group, and route table to test route/UDR administration, and is linked with ADO pipelines in `TIM-INFRA-MODULES` for development testing.

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
| <a name="module_onprem_routes"></a> [onprem\_routes](#module\_onprem\_routes) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_route_table_administration | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the route table | `string` | n/a | yes |
| <a name="input_udr_config"></a> [udr\_config](#input\_udr\_config) | The configuration of the UDR routes | <pre>object({<br/>    route_table_name = string<br/>    routes = list(object({<br/>      route_name     = string<br/>      address_prefix = string<br/>      next_hop_type  = string<br/>      next_hop_ip    = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "route_table_name": "axso-tf-test-route-table",<br/>  "routes": [<br/>    {<br/>      "address_prefix": "10.217.0.0/16",<br/>      "next_hop_ip": null,<br/>      "next_hop_type": "VirtualAppliance",<br/>      "route_name": "test-route1"<br/>    }<br/>  ]<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->