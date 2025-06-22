| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_subnet?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2455&branchName=main) | **v1.5.0** |**25/03/2025** |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Virtual Network Subnet Configuration](#azure-virtual-network-subnet-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Virtual Network Subnet Configuration

----------------------------

[Learn more about Azure Virtual Network Subnet in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-overview#virtual-network-and-subnets/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

A subnet is a range of IP addresses in the virtual network. You can divide a virtual network into multiple subnets for organization and security. Each NIC in a VM is connected to one subnet in one virtual network. NICs connected to subnets (same or different) within a virtual network can communicate with each other without any extra configuration

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_azurerm_subnet
- azurerm_network_security_group (optional)

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Virtual Network
- Network Security Group (Only if you want to use an existing one)

>**Note:**  
> If `default_name_network_security_group_create` is set to `true`  
> `custom_name_network_security_group should be` ""  
> And  
> If `default_name_network_security_group_create` is set to `false`  
> `custom_name_network_security_group` should contain the name of the existing network Security Group  


## Axso Naming convention example

----------------------------

We don't have a naming convention for subnets, as it's up to the users, but we recommend proper naming to help keep resources organized and easy to identify

**Construct:** `"<Environment>-<Service>-<Purpose>-subnet"`  
**Example:** `"uat-db-backend-subnet"`  

Naming convention for NSG will be based on the subnet name  

**Construct:** `"<Environment>-<Service>-<Purpose>-subnet-nsg"`  
**Example:** `"uat-db-backend-subnet-nsg"`  

# Terraform Files

----------------------------

## module.tf

```hcl
module "subnet" {
  for_each                                      = { for each in var.subnet_config : each.subnet_name => each }
  source                                        = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_subnet?ref=v.1.5.0"
  virtual_network_resource_group_name           = var.virtual_network_resource_group_name
  location                                      = var.location
  virtual_network_name                          = var.virtual_network_name
  custom_name_network_security_group            = each.value.custom_name_network_security_group
  route_table_name                              = each.value.route_table_name
  default_name_network_security_group_create    = each.value.default_name_network_security_group_create
  subnet_name                                   = each.value.subnet_name
  subnet_address_prefixes                       = each.value.subnet_address_prefixes
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  subnet_service_endpoints                      = each.value.subnet_service_endpoints
  subnets_delegation_settings                   = each.value.subnets_delegation_settings
}

```

## module.tf.tfvars

```hcl
location                            = "westeurope"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"


subnet_config = [
  {
    subnet_name                                = "uat-db-backend-subnet"
    subnet_address_prefixes                    = ["10.84.167.32/29"]
    default_name_network_security_group_create = true
    custom_name_network_security_group         = ""
    route_table_name                           = "route-spoke-nonprod-axso-xsgh"
    private_endpoint_network_policies_enabled  = "Enabled"
    subnet_service_endpoints                   = ["Microsoft.Sql"]
    subnets_delegation_settings                = {}

  },
  {
    subnet_name                                = "uat-api-frondend-subnet"
    subnet_address_prefixes                    = ["10.84.167.40/29"]
    default_name_network_security_group_create = false
    custom_name_network_security_group         = "nsg-cloudinfra-cloudflarensg-nonprod-axso-9xoj"
    route_table_name                           = "route-spoke-nonprod-axso-xsgh"
    private_endpoint_network_policies_enabled  = "Enabled"
    subnet_service_endpoints                   = []
    subnets_delegation_settings = {
      app-service-plan = [
        {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      ]
    }
  }
]




```

## variables.tf

```hcl

variable "location" {
  type        = string
  description = "The default location where the core network will be created"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the NSG and the Route table"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet, used to identify its purpose."
}

variable "subnet_config" {
  description = "List of subnet configurations."
  type = list(object({
    subnet_name                                   = string
    subnet_address_prefixes                       = list(string)
    default_name_network_security_group_create    = optional(bool)
    custom_name_network_security_group            = optional(string)
    route_table_name                              = optional(string)
    private_endpoint_network_policies_enabled     = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    subnet_service_endpoints                      = optional(list(string))
    subnets_delegation_settings = optional(map(list(object({
      name    = string
      actions = list(string)
    }))))
  }))
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
| [azurerm_network_security_group.network_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet.azure_network_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.security_group_association_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name_network_security_group"></a> [custom\_name\_network\_security\_group](#input\_custom\_name\_network\_security\_group) | The name of the Azure Network Security Group (NSG) to associate with the subnet, if applicable. | `string` | `null` | no |
| <a name="input_default_name_network_security_group_create"></a> [default\_name\_network\_security\_group\_create](#input\_default\_name\_network\_security\_group\_create) | In case is needed NSG will be created | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the core network will be created | `string` | n/a | yes |
| <a name="input_private_endpoint_network_policies_enabled"></a> [private\_endpoint\_network\_policies\_enabled](#input\_private\_endpoint\_network\_policies\_enabled) | Enable or Disable network policies for the private endpoint on the subnet. Possible values are 'Disabled', 'Enabled', 'NetworkSecurityGroupEnabled' and 'RouteTableEnabled'. Defaults to 'Disabled'. | `string` | `"Disabled"` | no |
| <a name="input_private_link_service_network_policies_enabled"></a> [private\_link\_service\_network\_policies\_enabled](#input\_private\_link\_service\_network\_policies\_enabled) | Controls whether network policies are enabled for private link services in the subnet. | `bool` | `false` | no |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | The name of the Azure Route Table to associate with the subnet, if applicable. | `string` | `""` | no |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | The address prefixes for the subnet, specifying its IP range. | `list(any)` | `[]` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet, used to identify its purpose. | `string` | `"dev"` | no |
| <a name="input_subnet_service_endpoints"></a> [subnet\_service\_endpoints](#input\_subnet\_service\_endpoints) | A list of service endpoints associated with the subnet. | `list(any)` | `[]` | no |
| <a name="input_subnets_delegation_settings"></a> [subnets\_delegation\_settings](#input\_subnets\_delegation\_settings) | Configuration delegations on subnet | `map(list(any))` | `{}` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet, used to identify its purpose. | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | n/a |
| <a name="output_subnet_subnet_id_map"></a> [subnet\_subnet\_id\_map](#output\_subnet\_subnet\_id\_map) | n/a |
<!-- END_TF_DOCS -->