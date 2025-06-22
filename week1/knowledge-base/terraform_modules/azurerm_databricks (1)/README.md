| **Build Status**      | **Latest Version** | **Date** |
|:----------------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_databricks?repoName=azurerm_databricks&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3768&repoName=azurerm_databricks&branchName=main) | **v1.0.0** | **08/10/2024** |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Databricks Configuration](#azure-databricks-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Databricks Configuration

----------------------------

[Learn more about Azure Databricks in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/databricks/introduction/)

## Service Description

----------------------------

Azure Databricks is a unified, open analytics platform for building, deploying, sharing, and maintaining enterprise-grade data, analytics, and AI solutions at scale. The Databricks Data Intelligence Platform integrates with cloud storage and security in your cloud account, and manages and deploys cloud infrastructure on your behalf.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_databricks_workspace
- azurerm_databricks_workspace_root_dbfs_customer_managed_key
- azurerm_databricks_access_connector

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group: A container for managing resources in Azure.
- Virtual Network: A network that allows resources to communicate securely.
- Two delegated subnets: One public and one private subnet delegated to Microsoft.Databricks/workspaces.
- Third subnet: Specifically for Private Endpoints.
- Key Vault: Used for storing the keys securely.


## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment` 

- **Construct - Azure databricks:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adb"`  

## Azure databricks

- **NonProd:** `axso-np-appl-cloudinfra-dev-adb`
- **Prod:** `axso-p-appl-cloudinfra-prod-adb`

# Terraform Files

----------------------------

## module.tf

```hcl

module "adb" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_databricks?ref=v1.0.0"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  subscription                        = var.subscription
  project_name                        = var.project_name
  environment                         = var.environment
  identity_type                       = var.identity_type
  umids_names                         = var.umids_names
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  public_subnet_name                  = var.public_subnet_name
  private_subnet_name                 = var.private_subnet_name
  pe_subnet_name                      = var.pe_subnet_name
  key_vault_name                      = var.key_vault_name
  sku                                 = var.sku
  frotend_private_access_enabled      = var.frotend_private_access_enabled
  storage_account_sku_name            = var.storage_account_sku_name
}


```

## module.tf.tfvars

```hcl

location                            = "West Europe"
environment                         = "dev"
project_name                        = "ssp"
subscription                        = "np"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
identity_type                       = "UserAssigned"
umids_names = [
  "axso-np-appl-ssp-test-umid"
]
public_subnet_name             = "adb-public"
private_subnet_name            = "adb-private"
frotend_private_access_enabled = "false"
sku                            = "premium"
storage_account_sku_name       = "Standard_LRS"

```

## variables.tf

```hcl

variable "location" {
  type        = string
  description = "The default location where the Static App will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created."
  default     = []
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "public_subnet_name" {
  type        = string
  description = "The name of the public subnet"

}

variable "private_subnet_name" {
  type        = string
  description = "The name of the private subnet"


}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet where the private endpoint will be created"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault where the keys are stored"

}

variable "frotend_private_access_enabled" {
  type        = bool
  description = "Should the front be private and access via Private Endpoint?"
  default     = false

}

variable "sku" {
  type        = string
  description = "The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial."
  default     = "standard"

}

variable "storage_account_sku_name" {
  type        = string
  description = "Storage account SKU name. Possible values include Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_GZRS, Standard_RAGZRS, Standard_ZRS, Premium_LRS or Premium_ZRS. Defaults to Standard_GRS."
  default     = "Standard_LRS"

}

```

## main.tf

```hcl

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}



```

----------------------------

# Input Description

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_access_connector.databricks_access_connector](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) | resource |
| [azurerm_databricks_workspace.databricks_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_databricks_workspace_root_dbfs_customer_managed_key.databricks_workspace_root_dbfs_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace_root_dbfs_customer_managed_key) | resource |
| [azurerm_key_vault_key.dbfs_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.disks_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.notebooks_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_network_security_group.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_endpoint.api_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.dbfs_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.dbfs_dfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.role_assignment_adbfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_databricks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_des](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet_network_security_group_association.private_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [random_string.cmk_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.rbac_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.status_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_service_principal.databricks_spn](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subnet.pe_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_frotend_private_access_enabled"></a> [frotend\_private\_access\_enabled](#input\_frotend\_private\_access\_enabled) | Should the front be private and access via Private Endpoint? | `bool` | `false` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault where the keys are stored | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the Static App will be created | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name) | The name of the private subnet | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name) | The name of the public subnet | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial. | `string` | `"standard"` | no |
| <a name="input_storage_account_sku_name"></a> [storage\_account\_sku\_name](#input\_storage\_account\_sku\_name) | Storage account SKU name. Possible values include Standard\_LRS, Standard\_GRS, Standard\_RAGRS, Standard\_GZRS, Standard\_RAGZRS, Standard\_ZRS, Premium\_LRS or Premium\_ZRS. Defaults to Standard\_GRS. | `string` | `"Standard_LRS"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umids_names"></a> [umids\_names](#input\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->