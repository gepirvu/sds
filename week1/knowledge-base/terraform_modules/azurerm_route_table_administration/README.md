| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_route_table_administration?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2458&branchName=main) | **v2.1.5** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**

# INDEX

----------------------------

1. [Route Table Administration Configuration](#route-table-administration-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Route Table Administration Configuration

----------------------------

[Learn more about Azure Route Tables in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
Axso terraform module for administering **AZURE User Defined Route Table Routes (UDRs)**.

## Deployed Resources

----------------------------

These all resources will be deployed when using Route Table Administration module.

- azurerm_route: Route Table Route

## Pre-requisites

----------------------------

- Resource Group should be created.
- Route Table should be created.

## Axso Naming convention example

No naming convention is applied to this module. Route name should be provided by the user in variable.

# Terraform Files

----------------------------

### module.tf

```hcl
module "onprem_routes" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_route_table_administration?ref=v2.1.5"
  for_each            = { for each in var.udr_config.routes : each.route_name => each }
  resource_group_name = var.resource_group_name
  route_table_name    = var.udr_config.route_table_name
  route_name          = each.value.route_name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
  next_hop_ip         = each.value.next_hop_ip
}
```

### module.tf.tfvars

```hcl
resource_group_name = "axso-np-appl-ssp-test-rg"

udr_config = {
  route_table_name = "axso-np-appl-ssp-test-rt"
  routes = [
    {
      route_name     = "prod_network_summary"
      address_prefix = "10.54.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_216"
      address_prefix = "10.216.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_217"
      address_prefix = "10.217.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_233"
      address_prefix = "10.233.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_226"
      address_prefix = "10.226.0.0/15"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    }
  ]
}
```

### variables.tf

```hcl
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the route table"
}

variable "udr_config" {
  type = object({
    route_table_name = string
    routes = list(object({
      route_name     = string
      address_prefix = string
      next_hop_type  = string
      next_hop_ip    = string
    }))
  })
  description = "The configuration of the UDR routes"
  default = {
    route_table_name = "axso-tf-test-route-table"
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
| [azurerm_route.network_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix) | route address prefix | `string` | n/a | yes |
| <a name="input_next_hop_ip"></a> [next\_hop\_ip](#input\_next\_hop\_ip) | route next hop type | `string` | `null` | no |
| <a name="input_next_hop_type"></a> [next\_hop\_type](#input\_next\_hop\_type) | route next hop type | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the route table | `string` | n/a | yes |
| <a name="input_route_name"></a> [route\_name](#input\_route\_name) | The name of the UDR route to be created | `string` | n/a | yes |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | The name of the the UDR table | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the route. |
<!-- END_TF_DOCS -->
