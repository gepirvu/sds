# Infra Team Test

This template is used for testing purposes only.


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
| <a name="module_axso_storage_account"></a> [axso\_storage\_account](#module\_axso\_storage\_account) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_storage_account | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault where the keys are stored | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the Storage account will be created | `string` | `"westeurope"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | List of storage accounts to be created and the relevant properties. | <pre>list(object({<br/>    storage_account_index            = string,<br/>    account_tier_storage             = string,<br/>    access_tier_storage              = string,<br/>    account_replication_type_storage = string,<br/>    account_kind_storage             = string,<br/>    public_network_access_enabled    = bool,<br/>    nfsv3_enabled                    = bool,<br/>    network_acl = object({<br/>      bypass                     = optional(list(string), ["AzureServices"]),<br/>      default_action             = optional(string, "Deny"),<br/>      ip_rules                   = optional(list(string), []),<br/>      virtual_network_subnet_ids = optional(list(string), [])<br/>    }),<br/>    is_hns_enabled               = bool,<br/>    network_name                 = string, #private endpoint network name<br/>    sa_subnet_name               = string, #private endpoint subnet name<br/>    network_resource_group_name  = string, #private endpoint network resource group name<br/>    delete_retention_policy_days = number,<br/>    container_names              = list(string)<br/>    identity_type                = string<br/>    umids_names                  = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->