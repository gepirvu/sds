# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

## Notes

Any notes or comments for the Infra team can be added here. (Please add any notes or comments with a date DD/MM/YYYY)

## Terraform Docs

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
| <a name="module_axso_postgresql_flexible_server"></a> [axso\_postgresql\_flexible\_server](#module\_axso\_postgresql\_flexible\_server) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_postgresql_flexible_server | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_auth_enabled"></a> [active\_directory\_auth\_enabled](#input\_active\_directory\_auth\_enabled) | (Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Entra ID authentication. Defaults to false. | `bool` | `true` | no |
| <a name="input_auto_grow_enabled"></a> [auto\_grow\_enabled](#input\_auto\_grow\_enabled) | (Optional) Specifies whether or not the PostgreSQL Flexible Server should automatically grow storage. Defaults to true. | `bool` | `true` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | (Optional) The number of days backups should be retained for. Changing this forces a new PostgreSQL Flexible Server to be created. | `number` | `7` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | (Optional) Specifies whether or not backups should be geo-redundant. Defaults to false. | `bool` | `false` | no |
| <a name="input_high_availability_mode"></a> [high\_availability\_mode](#input\_high\_availability\_mode) | (Required) The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant | `string` | `"ZoneRedundant"` | no |
| <a name="input_high_availability_required"></a> [high\_availability\_required](#input\_high\_availability\_required) | (Optional) Specifies whether or not the PostgreSQL Flexible Server should be high available. Defaults to false. | `bool` | `false` | no |
| <a name="input_identity_names"></a> [identity\_names](#input\_identity\_names) | The names of the User Managed Identities to associate with the PostgreSQL Flexible Server. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this PostgreSQL Flexible Server. The only possible value is UserAssigned. | `string` | `"UserAssigned"` | no |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | The name of the KeyVault to store the PostgreSQL server administrator login name and password | `string` | n/a | yes |
| <a name="input_keyvault_resource_group_name"></a> [keyvault\_resource\_group\_name](#input\_keyvault\_resource\_group\_name) | The name of the resource group in which the KeyVault is located | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | `string` | `"west europe"` | no |
| <a name="input_password_auth_enabled"></a> [password\_auth\_enabled](#input\_password\_auth\_enabled) | (Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Local password authentication. Defaults to false. | `bool` | `false` | no |
| <a name="input_pgsql_version"></a> [pgsql\_version](#input\_pgsql\_version) | (Optional) The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13, 14 and 15. Required when create\_mode is Default | `string` | `"11"` | no |
| <a name="input_postgresql_administrator_group"></a> [postgresql\_administrator\_group](#input\_postgresql\_administrator\_group) | The name of the EID group that will be the PostgreSQL server administrator | `string` | `null` | no |
| <a name="input_postgresql_flexible_server_databases"></a> [postgresql\_flexible\_server\_databases](#input\_postgresql\_flexible\_server\_databases) | (Optional) A map of databases which should be created on the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created. | <pre>map(object({<br/>    database_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_psql_subnet_name"></a> [psql\_subnet\_name](#input\_psql\_subnet\_name) | (for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. It can be a PE subnet or a delegated subnet. In case the provided subnet will be delegated, it should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | `"axso-np-appl-<project-name>-<environment>-rg"` | no |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | (Optional) Specifies whether the module should create the default routes in the route table for Entra ID authentication. Leave it null if the routes have already been added | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B\_Standard\_B1ms, GP\_Standard\_D2s\_v3, MO\_Standard\_E4s\_v3). | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | (Optional) The storage capacity of the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created. | `number` | `32768` | no |
| <a name="input_storage_tier"></a> [storage\_tier](#input\_storage\_tier) | (Optional) The name of storage performance tier for IOPS of the PostgreSQL Flexible Server. Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80.<br/>  The value is dependant of the storage\_mb, please check this documentation<br/>  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server#storage_tier-defaults-based-on-storage_mb" | `string` | `"P10"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | (for data source) The name of the virtual network to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_virtual_network_rg"></a> [virtual\_network\_rg](#input\_virtual\_network\_rg) | (for data source) The name of the virtual network resource group to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_vnet_integration_enable"></a> [vnet\_integration\_enable](#input\_vnet\_integration\_enable) | (for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->