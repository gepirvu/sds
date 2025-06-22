# Infra Team Test

This module is used to create a SQL Server in Azure and is for testing purposes only.

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
| <a name="module_axso_mssql_server"></a> [axso\_mssql\_server](#module\_axso\_mssql\_server) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mssql_server | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azuread_authentication_only"></a> [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Specifies whether Azure Active Directory only authentication is enabled. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_azurerm_mssql_server_vulnerability_assessment_enabled"></a> [azurerm\_mssql\_server\_vulnerability\_assessment\_enabled](#input\_azurerm\_mssql\_server\_vulnerability\_assessment\_enabled) | Specifies whether the vulnerability assessment is enabled on the MSSQL server. | `bool` | `false` | no |
| <a name="input_create_elastic_pool"></a> [create\_elastic\_pool](#input\_create\_elastic\_pool) | (Optional)Create an elastic pool for the MSSQL server. | `bool` | `false` | no |
| <a name="input_elastic_pool_config"></a> [elastic\_pool\_config](#input\_elastic\_pool\_config) | (Optional)<br/>type = object({<br/>  **name**                = The name of the elastic pool. This needs to be globally unique. Changing this forces a new resource to be created.<br/>  **max\_size\_gb**         = The max data size of the elastic pool in gigabytes.<br/>  **sku\_name**            = Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based or DTU based. Possible DTU based values are BasicPool, StandardPool, PremiumPool while possible vCore based values are GP\_Gen4, GP\_Gen5, GP\_Fsv2, GP\_DC, BC\_Gen4, BC\_Gen5, BC\_DC, HS\_PRMS, HS\_MOPRMS, or HS\_Gen5.<br/>  **sku\_tier**            = The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.<br/>  **zone\_redundant**      = (Optional) Whether or not this elastic pool is zone redundant. tier needs to be Premium for DTU based or BusinessCritical for vCore based sku.<br/>  **sku\_family**          = The family of hardware Gen4, Gen5, Fsv2 or DC.<br/>  **sku\_capacity**        = The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.<br/>  **per\_db\_min\_capacity** = The minimum capacity all databases are guaranteed.<br/>  **per\_db\_max\_capacity** = The maximum capacity any one database can consume.<br/>}) | <pre>object({<br/>    name                = string<br/>    max_size_gb         = number<br/>    sku_name            = string<br/>    sku_tier            = string<br/>    sku_family          = string<br/>    sku_capacity        = number<br/>    per_db_min_capacity = number<br/>    per_db_max_capacity = number<br/>    zone_redundant      = bool<br/>  })</pre> | <pre>{<br/>  "max_size_gb": 50,<br/>  "name": "test-elasticpool",<br/>  "per_db_max_capacity": 25,<br/>  "per_db_min_capacity": 0,<br/>  "sku_capacity": 125,<br/>  "sku_family": null,<br/>  "sku_name": "PremiumPool",<br/>  "sku_tier": "Premium",<br/>  "zone_redundant": true<br/>}</pre> | no |
| <a name="input_email_accounts"></a> [email\_accounts](#input\_email\_accounts) | Email accounts to send vulnerability assessment scan results, security alerts and audit logs | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault to store the MSSQL server password. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | `"westeurope"` | no |
| <a name="input_login_username"></a> [login\_username](#input\_login\_username) | The Azure login username details for the server. | `string` | n/a | yes |
| <a name="input_mssql_administrator_group"></a> [mssql\_administrator\_group](#input\_mssql\_administrator\_group) | The Azure AD group that will be the administrator for the MSSQL server. | `string` | n/a | yes |
| <a name="input_mssql_databases"></a> [mssql\_databases](#input\_mssql\_databases) | (Optional)<br/>type = list(object({ <br/>  **create\_db**                   = Create this database on the mssql server. (True/False)<br/>  **db\_name**                     = The name of the database. Changing this forces a new resource to be created.<br/>  **attach\_to\_elasticpool**       = Attach the database to an existing elastic pool on the mssql server or stand-alone.<br/>  **collation**                   = Specifies the collation of the database. Changing this forces a new resource to be created.<br/>  **create\_mode**                 = The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created. Defaults to Default.<br/>  **max\_size\_gb**                 = The max size of the database in gigabytes.<br/>  **min\_capacity**                = The min capacity of the database.<br/>  **sku\_name**                    = Specifies the name of the SKU used by the database. For example, GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource.<br/>  **zone\_redundant**              = Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases.<br/>  **storage\_account\_type**        = Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone. Defaults to Zone.<br/>  **short\_term\_retention\_days**   = The number of days to retain short term retention backups.<br/>  **ltr\_weekly\_retention**        = The weekly retention policy for long term retention backups.<br/>})) | <pre>list(object({<br/>    create_db                   = bool<br/>    db_name                     = string<br/>    attach_to_elasticpool       = bool<br/>    collation                   = string<br/>    create_mode                 = string<br/>    max_size_gb                 = number<br/>    min_capacity                = number<br/>    sku_name                    = string<br/>    storage_account_type        = string<br/>    zone_redundant              = bool<br/>    auto_pause_delay_in_minutes = number<br/>    short_term_retention_days   = number<br/>    ltr_weekly_retention        = string<br/><br/>  }))</pre> | <pre>[<br/>  {<br/>    "attach_to_elasticpool": true,<br/>    "auto_pause_delay_in_minutes": null,<br/>    "collation": "SQL_Latin1_General_CP1_CI_AS",<br/>    "create_db": true,<br/>    "create_mode": "Default",<br/>    "db_name": "test-db",<br/>    "ltr_weekly_retention": "P7D",<br/>    "max_size_gb": null,<br/>    "min_capacity": null,<br/>    "short_term_retention_days": 7,<br/>    "sku_name": "P2",<br/>    "storage_account_type": "Zone",<br/>    "zone_redundant": true<br/>  }<br/>]</pre> | no |
| <a name="input_mssql_subnet_name"></a> [mssql\_subnet\_name](#input\_mssql\_subnet\_name) | The name for data subnet, used in data source to get subnet ID, to enable the MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the MSSQL resources will be created. | `string` | n/a | yes |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created. | `string` | `"12.0"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account name to keep vulnerability assessment scan results and audit logs | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"np"` | no |
| <a name="input_threat_detection_policy"></a> [threat\_detection\_policy](#input\_threat\_detection\_policy) | The threat detection policy for the MSSQL server. | `string` | `"Disabled"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Virtual network name for the enviornment to enable MS SQL private endpoint. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->