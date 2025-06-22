| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_resource_group?repoName=azurerm_resource_group&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2321&repoName=azurerm_resource_group&branchName=main) | **v2.0.4** | 24/02/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**

# INDEX

----------------------------

1. [Resource Group Configuration](#resource-group-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Resource Group Configuration

----------------------------

[Learn more about Azure Resource Groups in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
This module can be used to create an Axso Resource Group in Azure.

## Deployed Resources

----------------------------

These all resources will be deployed when using Resource Group module.

- azurerm_resource_group: Deploys a Resource Group in Azure.

## Pre-requisites

----------------------------

- Azure Subscription

## Axso Naming convention example

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-rg"`  
**NonProd:** `axso-np-appl-dyos-dev-rg`  
**Prod:** `axso-p-appl-dyos-prod-rg`

# Terraform Files

----------------------------

### module.tf

```hcl
module "axso_resource_group" {
  for_each              = { for each in var.resource_groups : each.environment => each }  
  source                = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_resource_group?ref=v2.0.4"
  subscription          = each.value.subscription
  project_name          = each.value.project_name
  environment           = each.value.environment
  location              = var.location
}
```

### module.tf.tfvars

```hcl
location = "westeurope"
research_groups = [
  {
    subscription = "np"
    project_name = "dyos"
    environment  = "dev"
  },
  {
    subscription = "np"
    project_name = "dyos"
    environment  = "qa"
  },
  {
    subscription = "np"
    project_name = "dyos"
    environment  = "uat"
  },
  {
    subscription = "p"
    project_name = "dyos"
    environment  = "prod"
  }
]
```

### variables.tf

```hcl
variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
  default     = "westeurope"
}

variable "resource_groups" {
  type = list(object({
    subscription = string
    project_name = string
    environment  = string
  }))
  description = "The configuration of the resource groups to be created"
  default = [
    {
      subscription = "np"
      project_name = "dyos"
      environment  = "dev"
    },
    {
      subscription = "np"
      project_name = "dyos"
      environment  = "qa"
    },
    {
      subscription = "np"
      project_name = "dyos"
      environment  = "uat"
    },
    {
      subscription = "p"
      project_name = "dyos"
      environment  = "prod"
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.6 |
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
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group will be created. | `string` | `"westeurope"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. DYOS | `string` | `"dyos"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type (prod or nonprod) e.g. 'p' or 'np' | `string` | `"np"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | value of the resource group id |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | value of the resource group name |
<!-- END_TF_DOCS -->
