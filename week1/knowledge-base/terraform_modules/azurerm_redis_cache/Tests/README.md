# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.  

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.11.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_axso_redis_cache"></a> [axso\_redis\_cache](#module\_axso\_redis\_cache) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_redis_cache | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_keys_authentication_enabled"></a> [access\_keys\_authentication\_enabled](#input\_access\_keys\_authentication\_enabled) | (Optional) Whether or not access keys are enabled for this Redis instance. Defaults to true. | `bool` | `false` | no |
| <a name="input_active_directory_authentication_enabled"></a> [active\_directory\_authentication\_enabled](#input\_active\_directory\_authentication\_enabled) | (Optional) Whether or not Azure Active Directory authentication is enabled for this Redis instance. Defaults to false. | `bool` | `false` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | (Optional) The size of the Redis cache to deploy. Valid values are 0, 1, 2, 3, 4, 5, 6. Defaults to 1. | `number` | `1` | no |
| <a name="input_day_of_week"></a> [day\_of\_week](#input\_day\_of\_week) | (Optional) The day of the week when a cache can be patched. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. | `string` | `"Sunday"` | no |
| <a name="input_enable_patching"></a> [enable\_patching](#input\_enable\_patching) | (Optional) Whether or not the Redis instance should be patched. Defaults to false. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_family"></a> [family](#input\_family) | (Optional) The SKU family to use. Valid values are C (for Basic/Standard instances) and P (for Premium instances). Defaults to C. | `string` | `"C"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional) The type of Managed Service Identity to use. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet_details"></a> [pe\_subnet\_details](#input\_pe\_subnet\_details) | The details of the subnet to use for the private endpoint of the Redis cache. | <pre>object({<br>    subnet_name  = string<br>    vnet_name    = string<br>    vnet_rg_name = string<br>  })</pre> | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, cloudinfra, cp, cpm etc.. etc.. | `string` | `"cloudinfra"` | no |
| <a name="input_redis_fw_rules"></a> [redis\_fw\_rules](#input\_redis\_fw\_rules) | (Optional) A map of firewall rules to apply to the Redis instance. Each rule should have a name, start\_ip and end\_ip. | <pre>map(object({<br>    name     = string<br>    start_ip = string<br>    end_ip   = string<br>  }))</pre> | `null` | no |
| <a name="input_redis_umids"></a> [redis\_umids](#input\_redis\_umids) | The User Managed Identities to use for the Redis cache. | <pre>map(object({<br>    umid_name    = string<br>    umid_rg_name = string<br>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU of Redis to use. Valid values are Basic, Standard and Premium. Defaults to Basic. | `string` | `"Basic"` | no |
| <a name="input_start_hour_utc"></a> [start\_hour\_utc](#input\_start\_hour\_utc) | (Optional) The start hour after which cache patching can start. Possible values are 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11. | `number` | `0` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->