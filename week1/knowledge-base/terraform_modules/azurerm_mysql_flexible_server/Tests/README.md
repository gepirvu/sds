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
| <a name="module_axso_mysql_flexible_server"></a> [axso\_mysql\_flexible\_server](#module\_axso\_mysql\_flexible\_server) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mysql_flexible_server | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password_expiration_date"></a> [admin\_password\_expiration\_date](#input\_admin\_password\_expiration\_date) | (Required) The expiration date of the administrator password. | `string` | n/a | yes |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | (Required) The administrator login of the MySQL server. | `string` | n/a | yes |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | (Required) The allowed CIDRs to access the MySQL server. | `map(string)` | n/a | yes |
| <a name="input_databases"></a> [databases](#input\_databases) | (Required) The databases to create on the MySQL server. | `map(map(string))` | n/a | yes |
| <a name="input_delegated_subnet_details"></a> [delegated\_subnet\_details](#input\_delegated\_subnet\_details) | Details of the subnet to create the MySQL Flexible Server.Be sure to delegate the subnet to Microsoft.DBforMySQL/flexibleServers resource provider. | <pre>object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | (Required) Enable Geo-redundant backups. | `bool` | n/a | yes |
| <a name="input_high_availability_mode"></a> [high\_availability\_mode](#input\_high\_availability\_mode) | n/a | <pre>object({<br/>    mode = string<br/>  })</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | (Required) The name of the key vault. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the mysql server will be created | `string` | `"westeurope"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Required) The maintenance window configuration of the MySQL server. | <pre>object({<br/>    day_of_week  = number<br/>    start_hour   = number<br/>    start_minute = number<br/>  })</pre> | n/a | yes |
| <a name="input_mysql_aad_group"></a> [mysql\_aad\_group](#input\_mysql\_aad\_group) | (Required) The Azure AD group name of the MySQL administrator. | `string` | n/a | yes |
| <a name="input_mysql_options"></a> [mysql\_options](#input\_mysql\_options) | n/a | <pre>object({<br/>    audit_log_enabled = string<br/>  })</pre> | n/a | yes |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | (Required) The version of MySQL to use. Valid values are 5.7 and 8.0. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) The SKU name of the MySQL server. | `string` | n/a | yes |
| <a name="input_storage"></a> [storage](#input\_storage) | (Required) The storage configuration of the MySQL server. | <pre>object({<br/>    auto_grow_enabled  = bool<br/>    io_scaling_enabled = bool<br/>    iops               = number<br/>    size_gb            = number<br/>  })</pre> | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_umid_name"></a> [umid\_name](#input\_umid\_name) | (Required) The name of the user-assigned managed identity. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->