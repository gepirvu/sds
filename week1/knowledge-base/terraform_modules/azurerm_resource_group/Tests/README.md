# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

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
| <a name="module_axso_resource_group"></a> [axso\_resource\_group](#module\_axso\_resource\_group) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_resource_group | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group will be created. | `string` | `"westeurope"` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | The configuration of the resource groups to be created | <pre>list(object({<br/>    subscription = string<br/>    project_name = string<br/>    environment  = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "environment": "dev",<br/>    "project_name": "dyos",<br/>    "subscription": "np"<br/>  },<br/>  {<br/>    "environment": "qa",<br/>    "project_name": "dyos",<br/>    "subscription": "np"<br/>  },<br/>  {<br/>    "environment": "uat",<br/>    "project_name": "dyos",<br/>    "subscription": "np"<br/>  },<br/>  {<br/>    "environment": "prod",<br/>    "project_name": "dyos",<br/>    "subscription": "p"<br/>  }<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

