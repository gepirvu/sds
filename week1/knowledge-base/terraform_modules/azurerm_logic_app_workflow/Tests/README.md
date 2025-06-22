# Infra Team Test

This template deploys a logic app workflow and is linked with ADO pipelines in `TIM-INFRA-MODULES` that references `azurerm_logic_app_workflow` module for development testing.

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
| <a name="module_logicapp"></a> [logicapp](#module\_logicapp) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_logic_app_workflow | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies azure region/location where resources will be created. | `string` | `"westeurope"` | no |
| <a name="input_logic_app"></a> [logic\_app](#input\_logic\_app) | Short description for the usage of the logicapp | <pre>list(object({<br/>    logic_app_description = string<br/>    requires_identity     = bool<br/><br/>  }))</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of your RG | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | The name of your UMI | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->