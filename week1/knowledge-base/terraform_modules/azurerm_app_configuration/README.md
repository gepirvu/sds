| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_app_configuration?repoName=azurerm_app_configuration&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2386&repoName=azurerm_app_configuration&branchName=main) | **v2.1.4** | 26/02/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure App Configuration](#azure-app-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure App Configuration

----------------------------

[Learn more about Azure App Configuration in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure App Configuration provides a service to centrally manage application settings and feature flags. Modern programs, especially programs running in a cloud, generally have many components that are distributed in nature. Spreading configuration settings across these components can lead to hard-to-troubleshoot errors during an application deployment. Use App Configuration to store all the settings for your application and secure their accesses in one place.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_key_vault_key
- azurerm_role_assignment
- azurerm_app_configuration
- azurerm_private_endpoint
- azurerm_app_configuration_key

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment
- Key Vault

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-app-conf"`  
**NonProd:** `axso-np-appl-cloudinfra-dev-app-config`  
**Prod:** `axso-p-appl-cloudinfra-prod-app-config`  

# Terraform Files

----------------------------

## Module

```hcl
module "axso_app_config" {
  source   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_app_configuration?ref=v2.1.4"
  for_each = { for each in var.app_conf : each.environment => each }

  resource_group_name        = var.resource_group_name
  location                   = var.location
  key_vault_name             = var.key_vault_name
  project_name               = each.value.project_name
  subscription               = each.value.subscription
  environment                = each.value.environment
  sku                        = each.value.sku
  local_auth_enabled         = each.value.local_auth_enabled
  purge_protection_enabled   = each.value.purge_protection_enabled
  soft_delete_retention_days = each.value.soft_delete_retention_days
  identity_type              = each.value.identity_type
  pe_subnet                  = each.value.pe_subnet
  public_network_access      = each.value.public_network_access

  # App config key
  app_conf_key                 = each.value.app_conf_key
  app_conf_label               = each.value.app_conf_label
  app_conf_value               = each.value.app_conf_value
  app_conf_umids_names         = var.app_conf_umids_names
  app_conf_client_access_umids = var.app_conf_client_access_umids
}
```

## module.tf.tfvars

```hcl
#-----------------------------------------------------------------------------------------------------------------#
# General                                                                                                         #
#-----------------------------------------------------------------------------------------------------------------#
resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
key_vault_name      = "kv-ssp-0-nonprod-axso"

#-----------------------------------------------------------------------------------------------------------------#
# App configuration and app config keys                                                                           #
#-----------------------------------------------------------------------------------------------------------------#

app_conf = [
  {
    # Naming convention
    project_name = "cloudinfra"
    subscription = "np"
    environment  = "dv"

    # Standard settings
    sku                        = "standard"
    local_auth_enabled         = false
    purge_protection_enabled   = false
    soft_delete_retention_days = 7
    identity_type              = "UserAssigned"
    public_network_access      = "Enabled"


    pe_subnet = {
      subnet_name  = "pe"
      vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
      vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
    }

    # App config keys
    app_conf_key   = "app-key-1"
    app_conf_label = "app-key-1"
    app_conf_value = [
      {
        "ts_calc_server" : "AzureSmallJobs",
        "pool_id" : "axso-np-ts-uat-azure-small-batch-pool"
      },
      {
        "ts_calc_server" : "AzureLargeJobs",
        "pool_id" : "axso-np-ts-uat-azure-large-batch-pool"
      }
    ]
  }
]



app_conf_umids_names = ["axso-np-appl-ssp-test-umid"] # User Assigned Managed that will be assign to the App Configuration

app_conf_client_access_umids = ["bf28a8c4-21ac-41cf-9eeb-1d34d07c8bad"] # It is the same that above but for testing purposes. This should be the ID of the app service for example

```

## Variables

```hcl
#-----------------------------------------------------------------------------------------------------------------#
# General                                                                                                         #
#-----------------------------------------------------------------------------------------------------------------#

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the Key Vault to be used for storing the App Configuration Key Vault Key. Changing this forces a new resource to be created."
}


#-----------------------------------------------------------------------------------------------------------------#
# App configuration and app config keys                                                                           #
#-----------------------------------------------------------------------------------------------------------------#

variable "app_conf" {
  type = list(object({
    project_name               = string,
    subscription               = string,
    environment                = string,
    sku                        = string,
    local_auth_enabled         = bool,
    purge_protection_enabled   = bool,
    soft_delete_retention_days = number,
    identity_type              = string,
    public_network_access      = string,

    pe_subnet = object({
      subnet_name  = string
      vnet_name    = string
      vnet_rg_name = string
    })

    app_conf_key   = string,
    app_conf_label = string,
    app_conf_value = any
  }))

  default     = []
  description = "List of App Configurations to be created and the relevant properties."
}


variable "app_conf_umids_names" {
  type        = list(string)
  description = "(Required) List of User Assigned Managed Identity names to be assigned to the App Configuration. Changing this forces a new resource to be created."

}

#RBAC for clients managed identities

variable "app_conf_client_access_umids" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity IDs to give access to the App Configuration. It isnt the identity of the App Configuration. "
  default     = []

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
    time = {
      source  = "hashicorp/time"
      version = "= 0.12.1"
    }
  }
}

provider "azurerm" {
  features {
    app_configuration {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = false
    }
  }
  resource_provider_registrations = "none"
}

provider "azuread" {}

provider "time" {}

```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.12 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.12 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_app_configuration.appconf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration) | resource |
| [azurerm_app_configuration_key.appconf_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration_key) | resource |
| [azurerm_key_vault_key.app_config_cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.cmk_smi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cmk_umi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.devops_spi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.umid](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_string.cmk_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.rbac_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_conf_client_access_umids"></a> [app\_conf\_client\_access\_umids](#input\_app\_conf\_client\_access\_umids) | (Optional) The list of User Assigned Managed Identity IDs to give access to the App Configuration. It isnt the identity of the App Configuration. | `list(string)` | `[]` | no |
| <a name="input_app_conf_key"></a> [app\_conf\_key](#input\_app\_conf\_key) | (Required) The name of the App Configuration Key to create. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_app_conf_label"></a> [app\_conf\_label](#input\_app\_conf\_label) | (Optional) The label of the App Configuration Key. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_app_conf_umids_names"></a> [app\_conf\_umids\_names](#input\_app\_conf\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_app_conf_value"></a> [app\_conf\_value](#input\_app\_conf\_value) | (Optional) The value of the App Configuration Key. This should only be set when type is set to kv | `any` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | (Required) The name of the Key Vault to be used for storing the App Configuration Key Vault Key. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_local_auth_enabled"></a> [local\_auth\_enabled](#input\_local\_auth\_enabled) | (Optional) Whether local authentication methods is enabled. Defaults to true | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet"></a> [pe\_subnet](#input\_pe\_subnet) | n/a | <pre>object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | (Optional) The Public Network Access setting of the App Configuration. Possible values are Enabled and Disabled | `string` | `"Disabled"` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | (Optional) Whether Purge Protection is enabled. This field only works for standard sku. Defaults to false | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU name of the App Configuration. Possible values are free and standard. Defaults to free | `string` | n/a | yes |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | (Optional) The number of days that items should be retained for once soft-deleted. This field only works for standard sku. This value can be between 1 and 7 days. Defaults to 7. Changing this forces a new resource to be created. | `number` | `7` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_config_endpoint"></a> [app\_config\_endpoint](#output\_app\_config\_endpoint) | The URL of the App Configuration. |
| <a name="output_app_config_id"></a> [app\_config\_id](#output\_app\_config\_id) | The App Configuration ID. |
<!-- END_TF_DOCS -->
