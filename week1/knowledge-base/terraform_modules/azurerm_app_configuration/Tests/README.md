# Infra Team Test

This module is used to create an Azure app configuration and is for testing purposes only.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | = 0.12.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_axso_app_config"></a> [axso\_app\_config](#module\_axso\_app\_config) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_app_configuration | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_conf"></a> [app\_conf](#input\_app\_conf) | List of App Configurations to be created and the relevant properties. | <pre>list(object({<br/>    project_name               = string,<br/>    subscription               = string,<br/>    environment                = string,<br/>    sku                        = string,<br/>    local_auth_enabled         = bool,<br/>    purge_protection_enabled   = bool,<br/>    soft_delete_retention_days = number,<br/>    identity_type              = string,<br/>    public_network_access      = string,<br/><br/>    pe_subnet = object({<br/>      subnet_name  = string<br/>      vnet_name    = string<br/>      vnet_rg_name = string<br/>    })<br/><br/>    app_conf_key   = string,<br/>    app_conf_label = string,<br/>    app_conf_value = any<br/>  }))</pre> | `[]` | no |
| <a name="input_app_conf_client_access_umids"></a> [app\_conf\_client\_access\_umids](#input\_app\_conf\_client\_access\_umids) | (Optional) The list of User Assigned Managed Identity IDs to give access to the App Configuration. It isnt the identity of the App Configuration. | `list(string)` | `[]` | no |
| <a name="input_app_conf_umids_names"></a> [app\_conf\_umids\_names](#input\_app\_conf\_umids\_names) | (Required) List of User Assigned Managed Identity names to be assigned to the App Configuration. Changing this forces a new resource to be created. | `list(string)` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | (Required) The name of the Key Vault to be used for storing the App Configuration Key Vault Key. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->