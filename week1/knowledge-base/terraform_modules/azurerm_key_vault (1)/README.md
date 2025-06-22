| **Build Status** | **Latest Version** | **Date** |
|:---------------- |:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_key_vault?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2423&branchName=main) | **v3.1.2** | 24/03/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Key Vault Configuration](#key-vault-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Key Vault Configuration

----------------------------

[Learn more about Azure Key Vault in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/key-vault/general/overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
This module deploys a Key Vault in Azure with a private endpoint.
Azure Key Vault is one of several key management solutions in Azure, and helps solve the following problems:

- Secrets Management - Azure Key Vault can be used to Securely store and tightly control access to tokens, passwords, certificates, API keys, and other secrets
- Key Management - Azure Key Vault can be used as a Key Management solution. Azure Key Vault makes it easy to create and control the encryption keys used to encrypt your data.
- Certificate Management - Azure Key Vault lets you easily provision, manage, and deploy public and private Transport Layer Security/Secure Sockets Layer (TLS/SSL) certificates for use with Azure and your internal connected resources.

 It give you the option to add groups as admins (Key Vault Administrator) and readers(Key Vault Secrets User,Key Vault Reader) of they keyvault
You can add a secret expiry notification to receive an alert one month before the secret expires.

## Deployed Resources

----------------------------

These all resources will be deployed when using Key Vault module.

- azurerm_key_vault: Manages a keyvault
- azurerm_private_endpoint: Create the private endpoint for the keyvault
- azurerm_monitor_scheduled_query_rules_alert_v2: Create the alert rule if you want to be notified when a secret is about to expire.
- azurerm_monitor_action_group: Create the action group, which will include the emails to notify

## Pre-requisites

----------------

- Resource Group
- Virtual Network
- Long Analytics Workspace (Optional)

## Axso Naming convention example

The below example will create an **Azure Key Vault** for the project **prj** in the **nonprod** subscription: `"axso-dev-prj-kv-001"`. The 001 is created in base of the kv_number

**CL-AXSO-AZ-APPL-TEST-admin** group will be assigned to the Key vault as Key Vault Administrator and **CL-AXSO-AZ-APPL-TEST-readers** group will be assigned to the Key Vault as `Key Vault Reader` and `Key Vault Secrets User`. If you need more information about the RBAC roles in azure, visit [Azure Key Vault RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli)

The keyvault created in the example, will have only private access

# Terraform Files

----------------------------

## module.tf

```hcl

module "axso_key_vault" {
  source                        = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_key_vault?ref=v3.1.2"
  project_name                  = var.project_name
  environment                   = var.environment
  kv_number                     = var.kv_number
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  enabled_for_deployment        = var.enabled_for_deployment
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  admin_groups                  = var.admin_groups
  reader_groups                 = var.reader_groups
  public_network_access_enabled = var.public_network_access_enabled
  network_acls                  = var.network_acls
  network_resource_group_name   = var.network_resource_group_name
  virtual_network_name          = var.virtual_network_name
  pe_subnet_name                = var.pe_subnet_name
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  expire_notification           = var.expire_notification
  email_receiver                = var.email_receiver
}

```

## module.tfvars

```hcl

environment         = "dev"
project_name        = "prj"
location            = "westeurope"
resource_group_name = "axso-np-appl-ssp-test-rg"
kv_number           = "001"

sku_name = "standard"
enabled_for_deployment = true
enabled_for_disk_encryption = true
enabled_for_template_deployment = true

admin_groups  = ["CL-AXSO-AZ-SUB-cloudinfra-nonprod-Owner"]
reader_groups = [ "CL-AXSO-AZ-SUB-cloudinfra-nonprod-Reader" ]

virtual_network_name          = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                = "pe"
network_resource_group_name   = "rg-cloudinfra-nonprod-axso-ymiw"
public_network_access_enabled = false

log_analytics_workspace_name = "axso-np-appl-cloudinfra-dev-loga"
expire_notification          = true
email_receiver               = ["mario.martinezdiez@axpo.com", "2a8e6d57.axpogrp.onmicrosoft.com@ch.teams.ms"] #Teams channel email

# Specify Network ACLs
network_acls = {
  bypass         = "AzureServices"
  default_action = "Deny"
  ip_rules       = []

  virtual_network_subnet_ids = []
}

```

## variables.tf

```hcl

variable "location" {
  type        = string
  description = "The default location where the core network will be created"
  default     = "westeurope"
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "kv_number" {
  type        = string
  description = "The use case of the keyvault, to be used in the name. e.g. 001, or 002"
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the key vault"
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are \"standard\" and \"premium\"."
  type        = string
  default     = "standard"
}

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "admin_groups" {
  description = "Name of the groups that can do all operations on all keys, secrets and certificates."
  type        = list(string)
  default     = []
}

variable "reader_groups" {
  description = "IDs of the objects that can read all keys, secrets and certificates."
  type        = list(string)
  default     = []
}

variable "public_network_access_enabled" {
  description = "Whether the Key Vault is available from public network."
  type        = bool
  default     = false
}

variable "network_acls" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. Set to `null` to disable. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more information."
  type = object({
    bypass                     = optional(string, "None"),
    default_action             = optional(string, "Deny"),
    ip_rules                   = optional(list(string)),
    virtual_network_subnet_ids = optional(list(string)),
  })
  default = {}
}
# Private endpoint (used in data block to get subnet ID)
variable "virtual_network_name" {
  type        = string
  description = "Virtual network name for the enviornment to enable private endpoint."
}

variable "pe_subnet_name" {
  type        = string
  description = "The subnet name, used in data source to get subnet ID, to enable the private endpoint."
}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable  private endpoint."
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` days."
  type        = number
  default     = 7
}

variable "expire_notification" {
  description = "Send a notification before the secret expires"
  type        = bool
  default     = true

}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace to send diagnostic logs to."
  type        = string
  default     = null
}

variable "email_receiver" {
  description = "List of email receivers of secret expire notification."
  type        = list(string)
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
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_monitor_action_group.monitor_action_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.monitor_scheduled_query_rules_alert_v2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.rbac_keyvault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_keyvault_administrator_spi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_keyvault_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_keyvault_secrets_users](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [time_sleep.wait_120_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_group.rbac_keyvault_administrator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.rbac_keyvault_reader](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_subnet.sa_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

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
| <a name="input_webhook_receiver"></a> [webhook\_receiver](#input\_webhook\_receiver) | n/a | <pre>list(object({<br/>    name        = string,<br/>    service_uri = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | ID of the Key Vault. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Name of the Key Vault. |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | URI of the Key Vault |
<!-- END_TF_DOCS -->
