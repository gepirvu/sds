| **Build Status** | **Latest Version** | **date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_postgresql_flexible_server?repoName=azurerm_postgresql_flexible_server&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2565&repoName=azurerm_postgresql_flexible_server&branchName=main) | **v1.8.2** | 25/03/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [PostgreSQL flexible server Configuration](#postgresql-flexible-server-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# PostgreSQL flexible server Configuration

----------------------------
[Learn more about PostgreSQL flexible server in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/service-overview/?wt.mc_id=DT-MVP-5004771)

>**Note:**  
>
>- To adhere to Axpo's security policies, PostgreSQL Flexible Server cannot be deployed with public access enabled or firewall rules. Therefore, it requires the use of a delegated subnet. In some cases, we can request the removal of policies to use a Private Endpoint connection without enabling public access.
>- For PostgreSQL flexible server admin login, it is necessary to use EID groups. In exceptional use cases you can enable user password auth
>

## Service Description

----------------------------

Azure Database for PostgreSQL flexible server is a relational database service in the Microsoft cloud based on the PostgreSQL open source relational database.

## Deployed Resources

----------------------------

This module will deploy the following azurerm resources:

- azuread_group
- azurerm_key_vault_secret
- azurerm_postgresql_flexible_server
- azurerm_postgresql_flexible_server_active_directory_administrator
- azurerm_postgresql_flexible_server_database

## Pre-requisites

----------------------------

- Resource Group
- Virtual Network
- Dedicated subnet (Subnet delegation - Microsoft.DBforPostgreSQL/flexibleServers). 
- In the route table of the subnet you need to add two routes. AzureActiveDirectory -> Internet and  Subnet address space -> VnetLocal to avoid any issues using Entra ID authentication. If you specify the var.route_table_name the module will create it for you.
- NSG inbound rule to allow database subnet for the port 5432.
- Private DNS zone (privatelink.postgres.database.azure.com) > Already exist in Hub.
- Private DNS zone link > Already exists.
- KeyVault with RBACs (KeyVault Administrator) for the pipeline SPI.
- User assigned managed identity (optional)

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , and `environment`:  

**Construct:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-pgsql-flexi-server`  
**NonProd:** `axso-np-etools-dev-pgsql-flexi-server`  
**Prod:** `axso-p-etools-prod-pgsql-flexi-server`

# Terraform Files

----------------------------

## module.tf

```hcl

module "axso_postgresql_flexible_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_postgresql_flexible_server?ref=v1.8.2"

  # PostgreSQL flexible server general configuration
  resource_group_name = var.resource_group_name
  location            = var.location

  # Naming convention for postgresql flexible server
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # PostgreSQL flexible server configuration
  pgsql_version     = var.pgsql_version
  sku_name          = var.sku_name
  storage_mb        = var.storage_mb
  storage_tier      = var.storage_tier
  auto_grow_enabled = var.auto_grow_enabled

  # Network configuration
  vnet_integration_enable = var.vnet_integration_enable
  psql_subnet_name        = var.psql_subnet_name
  virtual_network_name    = var.virtual_network_name
  virtual_network_rg      = var.virtual_network_rg

  # Authentication configuration
  password_auth_enabled          = var.password_auth_enabled
  route_table_name               = var.route_table_name
  keyvault_name                  = var.keyvault_name
  keyvault_resource_group_name   = var.keyvault_resource_group_name
  active_directory_auth_enabled  = var.active_directory_auth_enabled
  postgresql_administrator_group = var.postgresql_administrator_group

  # Identity configuration
  identity_type  = var.identity_type
  identity_names = var.identity_names

  # High availability configuration
  high_availability_required = var.high_availability_required
  high_availability_mode     = var.high_availability_required ? var.high_availability_mode : null

  # Backup configuration
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # Databadses configuration
  postgresql_flexible_server_databases = var.postgresql_flexible_server_databases
}


```

## module.tf.tfvars

```hcl

# Common

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"

# PostgreSQL flexible server

# Naming convention for PostgreSQL flexible server
project_name = "cloudinfra"
subscription = "np"
environment  = "dev"

# PostgreSQL flexible server
pgsql_version     = "15"
sku_name          = "GP_Standard_D2ds_v5"
storage_mb        = 32768 # 32GB
storage_tier      = "P4"
auto_grow_enabled = false

# Network configuration
vnet_integration_enable = true
psql_subnet_name        = "psql" # If vnet_integration_enable = false, this will be the name of the PE subnet
virtual_network_name    = "vnet-cloudinfra-nonprod-axso-e3og"
virtual_network_rg      = "rg-cloudinfra-nonprod-axso-ymiw"

# Authentication configuration
password_auth_enabled          = true #Blocked by policy
route_table_name               = "route-spoke-nonprod-axso-xsgh"
active_directory_auth_enabled  = true
keyvault_name                  = "kv-ssp-0-nonprod-axso"
keyvault_resource_group_name   = "axso-np-appl-ssp-test-rg"
postgresql_administrator_group = "testaaa"
identity_type                  = "UserAssigned"
identity_names                 = ["axso-np-appl-ssp-test-umid"]

# High availability configuration
high_availability_required = false
high_availability_mode     = "ZoneRedundant" # when high_availability_required = true


# PostgreSQL flexible server - Database

postgresql_flexible_server_databases = {
  db1 = {
    database_name = "db1"
  }
}

#Backup configuration
geo_redundant_backup_enabled = true
backup_retention_days        = 7

```

## variables.tf

```hcl

# Prerequisites:

# Admin EID group for access to the PostgreSQL server

variable "postgresql_administrator_group" {
  type        = string
  default     = null
  description = "The name of the EID group that will be the PostgreSQL server administrator"
}

variable "keyvault_name" {
  type        = string
  description = "The name of the KeyVault to store the PostgreSQL server administrator login name and password"
}

variable "keyvault_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the KeyVault is located"
}

#----------------------------#
# PostgreSQL flexible server #
#----------------------------#

# General configuration

variable "project_name" {
  type        = string
  default     = "etools"
  description = "The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.."
}

variable "subscription" {
  type        = string
  default     = "p"
  description = "The subscription type e.g. 'p' or 'np'"
}

variable "environment" {
  type        = string
  default     = "prod "
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "resource_group_name" {
  type        = string
  default     = "axso-np-appl-<project-name>-<environment>-rg"
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "west europe"
  description = "(Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
}

# PostgreSQL flexible server

variable "pgsql_version" {
  type        = string
  default     = "11"
  description = "(Optional) The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13, 14 and 15. Required when create_mode is Default"
}

variable "sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)."
}

variable "storage_mb" {
  type        = number
  default     = 32768
  description = "(Optional) The storage capacity of the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "storage_tier" {
  type        = string
  default     = "P10"
  description = <<EOF
  (Optional) The name of storage performance tier for IOPS of the PostgreSQL Flexible Server. Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80.
  The value is dependant of the storage_mb, please check this documentation
  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server#storage_tier-defaults-based-on-storage_mb"
  EOF
}

variable "auto_grow_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should automatically grow storage. Defaults to true."
}

# Network configuration

variable "vnet_integration_enable" {
  type        = bool
  default     = true
  description = "(for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}


variable "psql_subnet_name" {
  type        = string
  default     = null
  description = "(for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. It can be a PE subnet or a delegated subnet. In case the provided subnet will be delegated, it should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "virtual_network_name" {
  type        = string
  default     = null
  description = "(for data source) The name of the virtual network to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "virtual_network_rg" {
  type        = string
  default     = null
  description = "(for data source) The name of the virtual network resource group to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

# Authentication configuration

variable "active_directory_auth_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Entra ID authentication. Defaults to false."
}


variable "route_table_name" {
  type        = string
  default     = null
  description = "(Optional) Specifies whether the module should create the default routes in the route table for Entra ID authentication. Leave it null if the routes have already been added"

}

variable "password_auth_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Local password authentication. Defaults to false."
}


variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this PostgreSQL Flexible Server. The only possible value is UserAssigned."
}

variable "identity_names" {
  type        = list(string)
  default     = []
  description = "The names of the User Managed Identities to associate with the PostgreSQL Flexible Server."
}

# High availability configuration

variable "high_availability_required" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should be high available. Defaults to false."
}

variable "high_availability_mode" {
  type        = string
  default     = "ZoneRedundant"
  description = "(Required) The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant"
}

# Backup configuration

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "(Optional) The number of days backups should be retained for. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not backups should be geo-redundant. Defaults to false."

}


#-------------------------------------#
# PostgreSQL flexible server database #
#-------------------------------------#

variable "postgresql_flexible_server_databases" {
  type = map(object({
    database_name = string
  }))

  default     = {}
  description = "(Optional) A map of databases which should be created on the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

```

<!-- BEGIN_TF_DOCS -->
### main.tf

```hcl
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azuread" {}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.password_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.username_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_postgresql_flexible_server.pgsqlflexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_active_directory_administrator.pgsqlflexible_server_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) | resource |
| [azurerm_postgresql_flexible_server_database.postgresql-flexible-server-database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_route.network_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_group.postgresql_administrator_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subnet.pgsql-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.pgsql_umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_auth_enabled"></a> [active\_directory\_auth\_enabled](#input\_active\_directory\_auth\_enabled) | (Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Entra ID authentication. Defaults to false. | `bool` | `true` | no |
| <a name="input_administrator_login_name"></a> [administrator\_login\_name](#input\_administrator\_login\_name) | The name of the PostgreSQL server administrator login | `string` | `"pgsqlflexiadmin"` | no |
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
| <a name="input_pass_length"></a> [pass\_length](#input\_pass\_length) | The length of the password | `number` | `16` | no |
| <a name="input_password_auth_enabled"></a> [password\_auth\_enabled](#input\_password\_auth\_enabled) | (Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Local password authentication. Defaults to false. | `bool` | `false` | no |
| <a name="input_password_secret_name"></a> [password\_secret\_name](#input\_password\_secret\_name) | The name of the secret in KeyVault to store the PostgreSQL server administrator password | `string` | `"pgsqlflexible-server-admin-password"` | no |
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
| <a name="input_username_secret_name"></a> [username\_secret\_name](#input\_username\_secret\_name) | The name of the secret in KeyVault to store the PostgreSQL server administrator login name | `string` | `"pgsqlflexible-server-admin"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | (for data source) The name of the virtual network to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_virtual_network_rg"></a> [virtual\_network\_rg](#input\_virtual\_network\_rg) | (for data source) The name of the virtual network resource group to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_vnet_integration_enable"></a> [vnet\_integration\_enable](#input\_vnet\_integration\_enable) | (for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The fully qualified domain name of the PostgreSQL Flexible Server. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the PostgreSQL Flexible Server. |
| <a name="output_name"></a> [name](#output\_name) | The name of the PostgreSQL Flexible Server. |
| <a name="output_public_network_access_enabled"></a> [public\_network\_access\_enabled](#output\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this PostgreSQL Flexible Server. |
<!-- END_TF_DOCS -->
