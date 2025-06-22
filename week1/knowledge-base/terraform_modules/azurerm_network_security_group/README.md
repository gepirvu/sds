| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_network_security_group?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2505&branchName=main) | **v1.3.5** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Network Security Group Configuration](#azure-network-security-group-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Network Security Group Configuration

----------------------------

[Learn more about Azure Network Security Group  in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. For each rule, you can specify source and destination, port, and protocol.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_network_security_group

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment`:  

The naming convention is derived from the following variable `subnet_name`:  

**Construct:** `"${var.subnet_name}-nsg"`  
**NonProd:** `np-data-subnet-nsg`  
**Prod:** `p-webapp-subnet-nsg`  

# Terraform Files

----------------------------

## module.tf

```hcl
module "axso_nsg" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_network_security_group?ref=v1.3.5"
  resource_group_name                 = var.resource_group_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  location                            = var.location
  nsgs                                = var.nsgs
}
```

## module.tf.tfvars

```hcl
resource_group_name                 = "rg-cloudinfra-nonprod-axso-ymiw" # Name of the network resource group
location                            = "westeurope"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"

nsgs = [
  {
    subnet_name         = "pe"
    associate_to_subnet = false
    nsg_rules = [
      {
        nsg_rule_name              = "DummyRule-Deny-Access-from"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "192.168.10.0/24"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        nsg_rule_name              = "DummyRule-Deny-Access-to"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "192.168.10.0/24"
      }
    ]
  },
  {
    subnet_name         = "aks"
    associate_to_subnet = true
    nsg_rules = [
      {
        nsg_rule_name              = "DummyRule-Deny-Access-from"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "192.168.10.0/24"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        nsg_rule_name              = "DummyRule-Deny-Access-to"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "192.168.10.0/24"
      }
    ]
  }  
]
```

## variables.tf

```hcl
##################################################
# VARIABLES                                      #
##################################################
variable "resource_group_name" {
  type        = string
  description = "value for the resource group name where the NSG should be created (normally the network resource group)"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "location" {
  type        = string
  description = "value for the location where the NSG should be created"
  default     = "westeurope"
}

variable "nsgs" {
  type = list(object({
    subnet_name         = string
    associate_to_subnet = bool


    nsg_rules = list(object({
      nsg_rule_name                = optional(string, "default_rule_name")
      priority                     = optional(string, "101")
      direction                    = optional(string, "Any")
      access                       = optional(string, "Allow")
      protocol                     = optional(string, "*")
      source_port_range            = optional(string, null)
      source_port_ranges           = optional(list(string), null)
      destination_port_range       = optional(string, null)
      destination_port_ranges      = optional(list(string), null)
      source_address_prefix        = optional(string, null)
      source_address_prefixes      = optional(list(string), null)
      destination_address_prefix   = optional(string, null)
      destination_address_prefixes = optional(list(string), null)
  })) }))

  default     = []
  description = "Specifies a list of objects to represent Network Security Group(NSG) rules"
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
| [azurerm_network_security_group.network_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | value for the location where the NSG should be created | `string` | `"westeurope"` | no |
| <a name="input_nsgs"></a> [nsgs](#input\_nsgs) | Specifies a list of objects to represent Network Security Group(NSG) rules | <pre>list(object({<br/>    subnet_name         = string<br/>    associate_to_subnet = bool<br/><br/><br/>    nsg_rules = list(object({<br/>      nsg_rule_name                = optional(string, "default_rule_name")<br/>      priority                     = optional(string, "101")<br/>      direction                    = optional(string, "Any")<br/>      access                       = optional(string, "Allow")<br/>      protocol                     = optional(string, "*")<br/>      source_port_range            = optional(string, null)<br/>      source_port_ranges           = optional(list(string), null)<br/>      destination_port_range       = optional(string, null)<br/>      destination_port_ranges      = optional(list(string), null)<br/>      source_address_prefix        = optional(string, null)<br/>      source_address_prefixes      = optional(list(string), null)<br/>      destination_address_prefix   = optional(string, null)<br/>      destination_address_prefixes = optional(list(string), null)<br/>  })) }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | value for the resource group name where the NSG should be created (normally the network resource group) | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | value for the id of the NSG |
| <a name="output_name"></a> [name](#output\_name) | value for the name of the NSG |
<!-- END_TF_DOCS -->
