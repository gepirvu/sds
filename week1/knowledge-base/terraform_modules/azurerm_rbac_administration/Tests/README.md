# Infra Team Test

This template deploys a Resource Group and tests Role assignment against the resource, linked with ADO pipelines in `TIM-INFRA-MODULES` that references `azurerm_rbac_administration` module for development testing.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_role-assignment"></a> [role-assignment](#module\_role-assignment) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_rbac_administration | ~{gitRef}~ |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.infra_test_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group will be created. | `string` | `"westeurope"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->