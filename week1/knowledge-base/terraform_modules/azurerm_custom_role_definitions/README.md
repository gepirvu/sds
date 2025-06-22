| **Build Status** | **Latest Version** | **date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_custom_role_definitions?repoName=azurerm_custom_role_definitions&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2382&repoName=azurerm_custom_role_definitions&branchName=main) | **v1.0.15** |  25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Custom Role Definitions Configuration](#custom-role-definitions-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Custom Role Definitions Configuration

----------------------------

[Learn more about Custom Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

A role definition is a collection of permissions. It's sometimes just called a role. A role definition lists the actions that can be performed, such as read, write, and delete. It can also list the actions that are excluded from allowed actions or actions related to underlying data.

## Deployed Resources

----------------------------

This module allows the following private DNS records to be deployed:

- azurerm_role_definition


## Pre-requisites

----------------------------

- None


## Axso Naming convention example

----------------------------

- Does not apply for Custom Roles


## Terraform Files

----------------------------

## module.tf

```
module "custom_roles" {
  source                  = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_custom_role_definitions?ref=~{gitRef}~"
  count                   = var.deploy_custom_roles == true ? 1 : 0
  custom_role_definitions = var.custom_role_definitions
}
```

## module.tf.tfvars

> :information_source: If no scope or assignable_scopes are defined then the current subscription ID will be used as the scope and assignable scopes.

```
deploy_custom_roles = true

custom_role_definitions = [
  {
    role_definition_name = "CUSTOM - App Settings Reader - tf-testing-~{environment}~"
    description          = "Allows view access for Azure Sites Configuration"
    permissions = {
      actions          = ["Microsoft.Web/sites/config/list/action", "Microsoft.Web/sites/config/read"]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
  },
  {
    role_definition_name = "CUSTOM - App Settings Admin - tf-testing-~{environment}~"
    description          = "Allows edit access for Azure Sites Configuration"
    permissions = {
      actions          = ["Microsoft.Web/sites/config/*"]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
  }
]
```

## variables.tf

```
variable "deploy_custom_roles" {
  type        = bool
  default     = false
  description = "Specifies whether custom RBAC roles should be created"
}

variable "custom_role_definitions" {
  type        = list(any)
  description = "Specifies a list of custom roles"
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
| [azurerm_role_definition.custom_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_role_definitions"></a> [custom\_role\_definitions](#input\_custom\_role\_definitions) | Specifies a list of custom roles | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_definition_ids"></a> [role\_definition\_ids](#output\_role\_definition\_ids) | List of Role Definition IDs. |
| <a name="output_role_definition_resource_ids"></a> [role\_definition\_resource\_ids](#output\_role\_definition\_resource\_ids) | List of Azure Resource Manager IDs for the resources. |
<!-- END_TF_DOCS -->
