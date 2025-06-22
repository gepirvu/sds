| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_storage_account?repoName=azurerm_storage_account&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2459&repoName=azurerm_storage_account&branchName=main) | **v5.0.4** | 24/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Storage Account Configuration](#storage-account-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Storage Account Configuration

----------------------------

[Learn more about Azure Storage Account in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
This module deploys a Storage Account in Azure with a private endpoint per service.
An Azure storage account contains all of your Azure Storage data objects: blobs, files, queues, and tables. The storage account provides a unique namespace for your Azure Storage data that's accessible from anywhere in the world over HTTP or HTTPS. Data in your storage account is durable and highly available, secure, and massively scalable.

## Deployed Resources

----------------------------

These all resources will be deployed when using Storage Account module.

- azurerm_storage_account: Manages a storage account
- azurerm_private_endpoint: Create the private endpoint for the storage account
- azurerm_storage_container: Create the storage container in case you need it

## Pre-requisites

----------------

- Resource Group
- Virtual Network
- Key vault
- User-Assigned Managed Identity (When identity_type = "UserAssigned" is set)


## Axso Naming convention example

The naming convention is derived from the following variables `subscription`, `project_name`, `environment` and `storage_account_number`  

**Construct:** `"axso4${var.subscription}4${var.environment}4${var.project_name}${var.storage_account_number}"`

**NonProd:** `axso4np4dev4etools01`  
**Prod:** `axso4p4prod4etools01`  

# Terraform Files

----------------------------

### module.tf

```hcl
module "axso_storage_account" {
  for_each                         = { for each in var.storage_accounts : each.storage_account_index => each }
  source                           = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_storage_account?ref=v5.0.4"
  location                         = var.location
  subscription                     = var.subscription
  environment                      = var.environment
  project_name                     = var.project_name
  resource_group_name              = var.resource_group_name
  key_vault_name                   = var.key_vault_name
  storage_account_index            = each.value.storage_account_index
  account_tier_storage             = each.value.account_tier_storage
  access_tier_storage              = each.value.access_tier_storage
  account_replication_type_storage = each.value.account_replication_type_storage
  account_kind_storage             = each.value.account_kind_storage
  public_network_access_enabled    = each.value.public_network_access_enabled
  net_rules                        = each.value.network_acl
  nfsv3_enabled                    = each.value.nfsv3_enabled
  is_hns_enabled                   = each.value.is_hns_enabled
  network_name                     = each.value.network_name
  sa_subnet_name                   = each.value.sa_subnet_name
  network_resource_group_name      = each.value.network_resource_group_name
  delete_retention_policy_days     = each.value.delete_retention_policy_days
  container_names                  = each.value.container_names
  identity_type                    = each.value.identity_type
  umids_names                      = each.value.umids_names
}
```

### module.tf.tfvars

```hcl
location            = "West Europe"
subscription        = "np"
environment         = "dev"
project_name        = "mds"
resource_group_name = "axso-np-appl-ssp-test-rg"
key_vault_name      = "kv-ssp-0-nonprod-axso"

storage_accounts = [
  {
    #Datalake storage with storage containers
    storage_account_index            = "1"
    account_tier_storage             = "Standard"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "StorageV2"
    public_network_access_enabled    = false #Only for testing - allows external test agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = false
    is_hns_enabled                   = true #Enable datalake
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = [] #optional
    # Specify Network ACLs
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"]
  },
  {
    #Blob storage with storage containers
    storage_account_index            = "2"
    account_tier_storage             = "Standard"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "StorageV2"
    is_hns_enabled                   = false
    public_network_access_enabled    = false #Only for testing - allows external tst agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = false
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = ["test1", "test2"] #optional - no containers
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"] #Mandatory for encryption  
  },
  {
    #Blob storage with nfsv3 enabled
    storage_account_index            = "3"
    account_tier_storage             = "Standard"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "StorageV2"
    is_hns_enabled                   = true
    public_network_access_enabled    = true #Only for testing - allows external tst agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = true
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = ["test1"] #optional - no containers
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"] #Mandatory for encryption      
  },
  {
    #Premium Files storage   enabled
    storage_account_index            = "4"
    account_tier_storage             = "Premium"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "FileStorage"
    is_hns_enabled                   = false
    public_network_access_enabled    = false #Only for testing - allows external tst agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = false
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = [] #optional - no containers  
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"] #Mandatory for encryption  
  }
]


```

### variables.tf

```hcl
variable "storage_accounts" {
  type = list(object({
    storage_account_index            = string,
    account_tier_storage             = string,
    access_tier_storage              = string,
    account_replication_type_storage = string,
    account_kind_storage             = string,
    public_network_access_enabled    = bool,
    nfsv3_enabled                    = bool,
    network_acl = object({
      bypass                     = optional(list(string), ["AzureServices"]),
      default_action             = optional(string, "Deny"),
      ip_rules                   = optional(list(string), []),
      virtual_network_subnet_ids = optional(list(string), [])
    }),
    is_hns_enabled               = bool,
    network_name                 = string, #private endpoint network name
    sa_subnet_name               = string, #private endpoint subnet name
    network_resource_group_name  = string, #private endpoint network resource group name
    delete_retention_policy_days = number,
    container_names              = list(string)
    identity_type                = string
    umids_names                  = list(string)
  }))
  default     = []
  description = "List of storage accounts to be created and the relevant properties."
}


variable "location" {
  type        = string
  description = "The default location where the Storage account will be created"
  default     = "westeurope"
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

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault where the keys are stored"

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
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  storage_use_azuread             = true
}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_key.key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.role_assignment_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_string.cmk_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.rbac_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subnet.sa_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier_storage"></a> [access\_tier\_storage](#input\_access\_tier\_storage) | Defines the access tier for BlobStorage, FileStorage, and StorageV2 accounts. | `string` | `"Hot"` | no |
| <a name="input_account_kind_storage"></a> [account\_kind\_storage](#input\_account\_kind\_storage) | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to Storage. Only V2 storage account are supported with retention policy | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type_storage"></a> [account\_replication\_type\_storage](#input\_account\_replication\_type\_storage) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS. | `string` | `"LRS"` | no |
| <a name="input_account_tier_storage"></a> [account\_tier\_storage](#input\_account\_tier\_storage) | Defines the Tier to use for this storage account. Valid options are Standard and Premium. For FileStorage accounts only Premium is valid. | `string` | `"Standard"` | no |
| <a name="input_container_names"></a> [container\_names](#input\_container\_names) | Defines the name of the containers to be created in the specified storage account | `list(string)` | `[]` | no |
| <a name="input_delete_retention_policy_days"></a> [delete\_retention\_policy\_days](#input\_delete\_retention\_policy\_days) | Number of days to keep soft delete. Setting this to 0 turns it off. | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | Enable Hierarchical Namespace (HNS) for the storage account | `bool` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault where the keys are stored | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the Storage account will be created | `string` | n/a | yes |
| <a name="input_net_rules"></a> [net\_rules](#input\_net\_rules) | Specify network rules. | <pre>object({<br/>    bypass                     = optional(list(string), ["AzureServices"]),<br/>    default_action             = optional(string, "Deny"),<br/>    ip_rules                   = optional(list(string), []),<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "bypass": [<br/>    "AzureServices"<br/>  ],<br/>  "default_action": "Deny"<br/>}</pre> | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Virtual network name for the enviornment to enable SA private endpoint. | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable storage private endpoint. | `string` | n/a | yes |
| <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled) | (Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false. This can only be true when account\_tier is Standard and account\_kind is StorageV2, or account\_tier is Premium and account\_kind is BlockBlobStorage. Additionally, the is\_hns\_enabled is true and account\_replication\_type must be LRS or RAGRS. | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Controls whether data in the account may be accessed from public networks. Defaults to false. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_sa_subnet_name"></a> [sa\_subnet\_name](#input\_sa\_subnet\_name) | The name for storage account subnet, used in data source to get subnet ID, to enable the storage account private endpoint. | `string` | n/a | yes |
| <a name="input_storage_account_index"></a> [storage\_account\_index](#input\_storage\_account\_index) | Custom numbering of storage account to create. (Will be appended at the end of the name e.g. 'mdsdevsa1') | `string` | `"1"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umids_names"></a> [umids\_names](#input\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the Storage Account | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | The list of container IDs |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | The list of container Names |
| <a name="output_resource_manager_ids"></a> [resource\_manager\_ids](#output\_resource\_manager\_ids) | The list of container resource manager IDs |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | value of the storage account id |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | value of the storage account name |
<!-- END_TF_DOCS -->
