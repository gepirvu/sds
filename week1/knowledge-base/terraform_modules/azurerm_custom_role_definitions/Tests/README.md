# Infra Team Test

This example creates two custom role definitions, `CUSTOM - App Settings Reader` and `CUSTOM - App Settings Admin` specifically to manage AZURE app services and functions **App settings**. Linked with ADO pipelines in `TIM-INFRA-MODULES` that references `azurerm_custom_role_definitions` module for development testing.

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
| <a name="module_custom_roles"></a> [custom\_roles](#module\_custom\_roles) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_custom_role_definitions | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_role_definitions"></a> [custom\_role\_definitions](#input\_custom\_role\_definitions) | Specifies a list of custom roles | `list(any)` | n/a | yes |
| <a name="input_deploy_custom_roles"></a> [deploy\_custom\_roles](#input\_deploy\_custom\_roles) | Specifies whether custom RBAC roles should be created | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->