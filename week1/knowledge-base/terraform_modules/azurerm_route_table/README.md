| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_route_table?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2491&branchName=main) | **v2.3.2** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Route Table Configuration](#route-table-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Route Table Configuration

----------------------------

[Learn more about Azure Route Tables in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
This module can be used to create an Axso Route Table in Azure. It also create a default route to the hub, you can disable that with the variable default_route_table

## Deployed Resources

----------------------------

These all resources will be deployed when using route table module.

- azurerm_route_table: This resource allows you to manage a Route Table within Azure Route Tables.
- azurerm_route: This resource allows you to manage a Route within a Route Table.

## Pre-requisites

----------------------------

- Resource Group

## Axso Naming convention example

The naming convention is derived from the following variables `subscription`, `project_name`, `environment` and `usecase`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-rt"`  
**NonProd:** `axso-np-appl-etools-dev-psql-rt`  
**Prod:** `axso-p-appl-etools-prod-psql-rt`  

# Terraform Files

----------------------------

### module.tf

```hcl
module "axso_rt" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_route_table?ref=v2.3.2"
  resource_group_name           = var.resource_group_name
  subscription                  = var.subscription
  project_name                  = var.project_name
  environment                   = var.environment
  location                      = var.location
  usecase                       = var.usecase
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  default_hub_route             = var.default_hub_route
  udr_config                    = var.udr_config

}

```

### module.tf.tfvars

```hcl
resource_group_name           = "axso-np-appl-ssp-test-rg"
subscription                  = "np"
project_name                  = "dyos"
environment                   = "test"
location                      = "westeurope"
usecase                       = "psql"
bgp_route_propagation_enabled = false
default_hub_route             = true
udr_config = {
  routes = [
    {
      route_name     = "PSQL_AzureActiveDirectory"
      address_prefix = "AzureActiveDirectory"
      next_hop_type  = "Internet"
      next_hop_ip    = null
    },
    {
      route_name     = "PSQL_SUBNET_DEV"
      address_prefix = "10.84.189.160/28"
      next_hop_type  = "VnetLocal"
      next_hop_ip    = null
    },
    {
      route_name     = "PSQL_SUBNET_UAT"
      address_prefix = "10.84.189.176/28"
      next_hop_type  = "VnetLocal"
      next_hop_ip    = null
    }
  ]
}
```

### variables.tf

```hcl
variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
  default     = "np"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "environment" {
  type        = string
  description = "The short name of the environment e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "usecase" {
  type        = string
  description = "The usecase of the route table to use in the route table name"
  default     = "psql"
}

variable "location" {
  type        = string
  description = "The location to create the UDR table e.g westeurope"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to place the UDR in (normally core network resource group)"
}

variable "bgp_route_propagation_enabled" {
  type        = bool
  default     = false
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table. "
}

variable "default_hub_route" {
  type        = bool
  default     = true
  description = "Boolean flag which controls the creation of the default route table. True means create."
}

variable "udr_config" {
  type = object({
    routes = list(object({
      route_name     = string
      address_prefix = string
      next_hop_type  = string
      next_hop_ip    = string
    }))
  })
  description = "The configuration of the UDR routes"
  default = {
    routes = [
      {
        route_name     = "test-route1"
        address_prefix = "10.217.0.0/16"
        next_hop_type  = "VirtualAppliance"
        next_hop_ip    = null
      }
    ]
  }
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
| [azurerm_route.default_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.network_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp_route_propagation_enabled"></a> [bgp\_route\_propagation\_enabled](#input\_bgp\_route\_propagation\_enabled) | Boolean flag which controls propagation of routes learned by BGP on that route table. | `bool` | `false` | no |
| <a name="input_default_hub_route"></a> [default\_hub\_route](#input\_default\_hub\_route) | Boolean flag which controls the creation of the default route to the hub. True means create. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name of the environment e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location to create the UDR table e.g westeurope | `string` | `"westeurope"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to place the UDR in (normally core network resource group) | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |
| <a name="input_udr_config"></a> [udr\_config](#input\_udr\_config) | The configuration of the UDR routes | <pre>object({<br/>    routes = list(object({<br/>      route_name     = string<br/>      address_prefix = string<br/>      next_hop_type  = string<br/>      next_hop_ip    = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "routes": [<br/>    {<br/>      "address_prefix": "10.217.0.0/16",<br/>      "next_hop_ip": null,<br/>      "next_hop_type": "VirtualAppliance",<br/>      "route_name": "test-route1"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_usecase"></a> [usecase](#input\_usecase) | The usecase of the route table to use in the route table name | `string` | `"psql"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_name"></a> [route\_table\_name](#output\_route\_table\_name) | value of the route table name |
<!-- END_TF_DOCS -->
