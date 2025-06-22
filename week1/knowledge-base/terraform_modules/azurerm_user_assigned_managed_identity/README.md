| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_user_assigned_managed_identity?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2457&branchName=main) | **v1.5.5** | **27/03/2025** |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Managed Identities Configuration](#azure-managed-identities-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Managed identities Configuration

----------------------------

[Learn more about Azure Managed identities in the Microsoft Documentation](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Managed identities provide an automatically managed identity in Microsoft Entra ID for applications to use when connecting to resources that support Microsoft Entra authentication. Applications can use managed identities to obtain Microsoft Entra tokens without having to manage any credentials.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_user_assigned_identity

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name`, `environment` and `umid_use`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.umid_use}-umid"`  

**NonProd:** `axso-np-appl-etools-dev-management-umid`  
**Prod:** `axso-p-appl-etools-prod-management-umid`  

# Terraform Files

----------------------------

## module.tf

```hcl

module "umid" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_user_assigned_managed_identity?ref=v1.5.5"
  umid_name           = var.umid_name
  location            = var.location
  subscription        = var.subscription
  environment         = var.environment
  project_name        = var.project_name
  resource_group_name = var.resource_group_name
}

```

## module.tf.tfvars

```hcl
location            = "West Europe"
subscription        = "np"
environment         = "dev"
project_name        = "ssp"
umid_name           = ["inventory", "database"]
resource_group_name = "axso-np-appl-ssp-test-rg"
```

## Variables

```hcl

variable "location" {
  type        = string
  description = "The default location where the User managed identities will be created"
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
  description = "The name of the resource group in which to create the user assigned identity."
}

variable "umid_name" {
  type        = list(string)
  description = "What is the name for the managed identity?."
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
| [azurerm_user_assigned_identity.user_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the user assigned identity is created. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the user assigned identity. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umid_name"></a> [umid\_name](#input\_umid\_name) | What is the name for the managed identity?. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | User Managed Identity Tenant ID |
| <a name="output_uid_client_id"></a> [uid\_client\_id](#output\_uid\_client\_id) | User Managed Identity Client ID |
| <a name="output_uid_id"></a> [uid\_id](#output\_uid\_id) | User Managed Identity ID |
| <a name="output_uid_name"></a> [uid\_name](#output\_uid\_name) | User Managed Identity Tenant ID |
| <a name="output_uid_principal_id"></a> [uid\_principal\_id](#output\_uid\_principal\_id) | User Managed Identity ID |
<!-- END_TF_DOCS -->
