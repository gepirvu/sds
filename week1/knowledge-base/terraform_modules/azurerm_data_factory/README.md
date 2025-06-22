| **Build Status**      | **Latest Version** | **Date** |
|:----------------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_data_factory?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3683&branchName=main) | **v1.0.7**         | 25/03/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Data Factory Configuration](#data-factory-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Data Factory Configuration

----------------------------

[Learn more about Azure Data Factory in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/data-factory/introduction/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Data Factory is the cloud-based ETL and data integration service that allows you to create data-driven workflows for orchestrating data movement and transforming data at scale. Using Azure Data Factory, you can create and schedule data-driven workflows (called pipelines) that can ingest data from disparate data stores

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_data_factory
- azurerm_private_endpoint
- azurerm_data_factory_integration_runtime_azure
- azurerm_data_factory_integration_runtime_self_hosted

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Virtual Network

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment` and `usecase`:

- **Construct - Azure data factory:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adf"`  
- **Construct - Azure Integration Runtime:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adf-${name}"`

## Azure data factory

- **NonProd:** `axso-np-appl-cloudinfra-dev-adf`
- **Prod:** `axso-p-appl-cloudinfra-prod-adf`

## Azure Integration Runtime

- **NonProd:** `axso-np-appl-cloudinfra-dev-adf-myintegrationruntime`
- **Prod:** `axso-p-appl-cloudinfra-prod-adf-myintegrationruntime`

# Terraform Files

----------------------------

## module.tf

```hcl

module "axso_data_factory" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_factory?ref=v1.0.7"
  # General
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_name      = var.key_vault_name

  # Naming convention
  subscription = var.subscription
  project_name = var.project_name
  environment  = var.environment

  identity_type = var.identity_type
  umids_names   = var.umids_names

  managed_virtual_network_enabled     = var.managed_virtual_network_enabled
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  pe_subnet_name                      = var.pe_subnet_name

  global_parameters  = var.global_parameters
  vsts_configuration = var.vsts_configuration

  purview_id = var.purview_id

  azure_integration_runtimes       = var.azure_integration_runtimes
  self_hosted_integration_runtimes = var.self_hosted_integration_runtimes

}

```

## module.tf.tfvars

```hcl

resource_group_name                 = "axso-np-appl-ssp-test-rg"
location                            = "westeurope"
project_name                        = "cloudinfra"
subscription                        = "np"
environment                         = "dev"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
identity_type                       = "UserAssigned"
umids_names                         = ["axso-np-appl-ssp-test-umid"]
managed_virtual_network_enabled     = false
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe"

global_parameters = [
  {
    name  = "param6"
    type  = "String"
    value = "some string"
  },
  {
    name  = "param7"
    type  = "Int"
    value = "42"
  },
  {
    name  = "param1"
    type  = "Object"
    value = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
  },
  {
    name  = "param2"
    type  = "Array"
    value = "[\"value1\", \"value2\", \"value3\"]"
  }
]

vsts_configuration = null

purview_id = null

azure_integration_runtimes = [
  {
    name                    = "rn1"
    description             = "Integration Runtime 1"
    cleanup_enabled         = true
    compute_type            = "General"
    core_count              = 8
    time_to_live_min        = 0
    virtual_network_enabled = false
  }
]

self_hosted_integration_runtimes = [
  {
    name        = "SelfHostedIntegrationRuntime1"
    description = "Self Hosted Integration Runtime 1"
  }
]


```

## variables.tf

```hcl

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "project"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the data factory"
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "key_vault_name" {
  description = "Name of the keyVault"
  default     = null
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the Data Factory. Changing this forces a new resource to be created."
  default     = []
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the Data Factory should be provisioned with a managed virtual network. Defaults to false."
  default     = false

}


variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet where the private endpoint will be created"
}

variable "global_parameters" {
  description = "A list of global parameters to be created."
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

variable "vsts_configuration" {
  description = "VSTS configuration"
  type = object({
    account_name = string
    project_name = string
    repository   = string
    branch       = string
    root_folder  = string
    tenant_id    = string
    service_id   = string
    secret_id    = string
  })
  default = null

}

variable "purview_id" {
  description = "The ID of the Purview account to associate with the Data Factory."
  type        = string
  default     = null

}

variable "azure_integration_runtimes" {
  description = "A list of Azure Integration Runtimes for Data Factory."
  type = list(object({
    name                    = string
    description             = optional(string, null)
    cleanup_enabled         = optional(bool, true)
    compute_type            = optional(string, "General")
    core_count              = optional(number, 8)
    time_to_live_min        = optional(number, 0)
    virtual_network_enabled = optional(bool, true)
  }))
  default = [
    {
      name                    = "runtime1"
      description             = "Integration Runtime 1"
      cleanup_enabled         = true
      compute_type            = "General"
      core_count              = 8
      time_to_live_min        = 0
      virtual_network_enabled = false
    }
  ]
}

variable "self_hosted_integration_runtimes" {
  description = "A list of Azure Integration Runtimes Self Hosted for Data Factory."
  type = list(object({
    name        = string
    description = string
  }))
  default = [
    {
      name        = "runtime1"
      description = "Integration Runtime 1"
    }
  ]
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

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory.data_factory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |
| [azurerm_data_factory_integration_runtime_azure.data_factory_integration_runtime_azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure) | resource |
| [azurerm_data_factory_integration_runtime_self_hosted.data_factory_integration_runtime_self_hosted](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_subnet.pe_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_integration_runtimes"></a> [azure\_integration\_runtimes](#input\_azure\_integration\_runtimes) | A list of Azure Integration Runtimes for Data Factory. | <pre>list(object({<br/>    name                    = string<br/>    description             = optional(string, null)<br/>    cleanup_enabled         = optional(bool, true)<br/>    compute_type            = optional(string, "General")<br/>    core_count              = optional(number, 8)<br/>    time_to_live_min        = optional(number, 0)<br/>    virtual_network_enabled = optional(bool, true)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cleanup_enabled": true,<br/>    "compute_type": "General",<br/>    "core_count": 8,<br/>    "description": "Integration Runtime 1",<br/>    "name": "runtime1",<br/>    "time_to_live_min": 0,<br/>    "virtual_network_enabled": false<br/>  }<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_global_parameters"></a> [global\_parameters](#input\_global\_parameters) | A list of global parameters to be created. | <pre>list(object({<br/>    name  = string<br/>    type  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the keyVault | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | (Optional) Specifies whether the Data Factory should be provisioned with a managed virtual network. Defaults to false. | `bool` | `false` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of the Purview account to associate with the Data Factory. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the data factory | `string` | n/a | yes |
| <a name="input_self_hosted_integration_runtimes"></a> [self\_hosted\_integration\_runtimes](#input\_self\_hosted\_integration\_runtimes) | A list of Azure Integration Runtimes Self Hosted for Data Factory. | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "Integration Runtime 1",<br/>    "name": "runtime1"<br/>  }<br/>]</pre> | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_umids_names"></a> [umids\_names](#input\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the Data Factory. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |
| <a name="input_vsts_configuration"></a> [vsts\_configuration](#input\_vsts\_configuration) | VSTS configuration | <pre>object({<br/>    account_name = string<br/>    project_name = string<br/>    repository   = string<br/>    branch       = string<br/>    root_folder  = string<br/>    tenant_id    = string<br/>    service_id   = string<br/>    secret_id    = string<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_factory_id"></a> [data\_factory\_id](#output\_data\_factory\_id) | The id of the Data Factory |
| <a name="output_data_factory_name"></a> [data\_factory\_name](#output\_data\_factory\_name) | The name of the Data Factory |
<!-- END_TF_DOCS -->
