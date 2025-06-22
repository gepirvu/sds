# Infra Team Test

This template deploys a key vault and is linked with ADO pipelines in `TIM-INFRA-MODULES` that references `azurerm_key_vault` module for development testing.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_axso_key_vault"></a> [axso\_key\_vault](#module\_axso\_key\_vault) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_key_vault | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_groups"></a> [admin\_groups](#input\_admin\_groups) | Name of the groups that can do all operations on all keys, secrets and certificates. | `list(string)` | `[]` | no |
| <a name="input_email_receiver"></a> [email\_receiver](#input\_email\_receiver) | List of email receivers of secret expire notification. | `list(string)` | `[]` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_expire_notification"></a> [expire\_notification](#input\_expire\_notification) | Send a notification before the secret expires | `bool` | `true` | no |
| <a name="input_kv_number"></a> [kv\_number](#input\_kv\_number) | The use case of the keyvault, to be used in the name. e.g. 001, or 002 | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the core network will be created | `string` | `"westeurope"` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | The name of the Log Analytics workspace to send diagnostic logs to. | `string` | `null` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. Set to `null` to disable. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more information. | <pre>object({<br/>    bypass                     = optional(string, "None"),<br/>    default_action             = optional(string, "Deny"),<br/>    ip_rules                   = optional(list(string)),<br/>    virtual_network_subnet_ids = optional(list(string)),<br/>  })</pre> | `{}` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable  private endpoint. | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The subnet name, used in data source to get subnet ID, to enable the private endpoint. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether the Key Vault is available from public network. | `bool` | `false` | no |
| <a name="input_reader_groups"></a> [reader\_groups](#input\_reader\_groups) | IDs of the objects that can read all keys, secrets and certificates. | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the key vault | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are "standard" and "premium". | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` days. | `number` | `7` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Virtual network name for the enviornment to enable private endpoint. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->