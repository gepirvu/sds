| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_linux_virtual_machine_scale_set?repoName=azurerm_linux_virtual_machine_scale_set&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=4062&repoName=azurerm_linux_virtual_machine_scale_set&branchName=main) | **v1.0.0** | 16/12/2024 |  

# INDEX
-------

1. [Linux Virtual Machine Scale Sets configuration](#linux-virtual-machine-scale-sets-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Linux Virtual Machine Scale Sets configuration
------------------------------------------------

[Learn more about <Azure Resource> in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/)

## Service Description
----------------------

Azure Virtual Machine Scale Sets let you create and manage a group of load balanced VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule. Scale sets provide the following key benefits:

>- Easy to create and manage multiple VMs
>- Provides high availability and application resiliency by distributing VMs across availability zones or fault domains
>- Allows your application to automatically scale as resource demand changes
>- Works at large-scale

With Flexible orchestration, Azure provides a unified experience across the Azure VM ecosystem. Flexible orchestration offers high availability guarantees (up to 1000 VMs) by spreading VMs across fault domains in a region or within an Availability Zone. This enables you to scale out your application while maintaining fault domain isolation that is essential to run quorum-based or stateful workloads, including:

>- Quorum-based workloads
>- Open-source databases
>- Stateful applications
>- Services that require high availability and large scale
>- Services that want to mix virtual machine types or leverage Spot and on-demand VMs together
>- Existing Availability Set applications

## Deployed Resources
---------------------

This module will deploy the following azurerm resources:

- azurerm_disk_encryption_set (DES + Key)
- tls_private_key (will be stored in the Keyvault)
- azurerm_linux_virtual_machine_scale_set

## Pre-requisites
-----------------

It is assumed that the following resources already exists:

- Resource Group
- Key Vault
- Virtual network and subnet
- User assigned managed identity (optional)

## Axso Naming convention example
---------------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment` and `usecase`:

- **Construct:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-linux-vmss`  
- **NonProd:** `axso-np-appl-ci-dev-buildagent-linux-vmss`
- **Prod:** `axso-p-appl-ci-dev-buildagent-linux-vmss`

# Terraform Files
-----------------

## module.tf

```hcl
module "axso_linux_vmss" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_virtual_machine_scale_set?ref=v1.0.0"

  # Naming convention
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment
  usecase      = var.usecase
  
  # VMSS properties
  resource_group_name  = var.resource_group_name
  location             = var.location 
  linux_vmss_sku       = var.linux_vmss_sku
  instances            = var.instances
  overprovision        = var.overprovision
  os_upgrade_mode      = var.os_upgrade_mode
  availability_zones   = var.availability_zones 
  source_image_id      = var.source_image_id

  # VMSS Network
  dns_servers = var.dns_servers
  vmss_subnet = var.vmss_subnet

  # VMSS Authentication
  admin_username         = var.admin_username
  admin_ssh_key_data     = var.admin_ssh_key_data
  generate_admin_ssh_key = var.generate_admin_ssh_key
  identity_type          = var.identity_type
  managed_identities     = var.managed_identities

  # VMSS Image
  source_image = var.source_image

 # VMSS Disk
  os_disk_config               = var.os_disk_config
  enable_data_disk             = var.enable_data_disk
  data_disks                   = var.enable_data_disk ? var.data_disks : []

  # Keyvault
  keyvault_details   = var.keyvault_details

  # Extension
  extension_config = var.extension_config
}
```

## module.tf.tfvars

```hcl
# Naming convention

project_name = "ci"
subscription = "np"
environment  = "dev"
usecase      = "buildagent"


# VMSS properties 

resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "West Europe"
linux_vmss_sku      = "Standard_D2as_v4"
instances           = 1
overprovision       = false
os_upgrade_mode     = "Manual"
availability_zones  = null
source_image_id     = null

# VMSS Network

vmss_subnet = {
  subnet_name  = "vmss"
  vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
  vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
}

# VMSS Authentication 

admin_username         = "adminuser"
generate_admin_ssh_key = true
identity_type          = "SystemAssigned, UserAssigned"

managed_identities = [
  {
    name                = "axso-np-appl-ssp-test-vmss-umid"
    resource_group_name = "axso-np-appl-ssp-test-rg"
  }
]

# VMSS Image

source_image = {
  offer     = "UbuntuServer"
  publisher = "Canonical"
  sku       = "18.04-LTS"
  version   = "latest"
}

# VMSS Disk 

os_disk_config = {
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 30
}

enable_data_disk = true

data_disks = [
  {
    #name                 = "datadisk1"
    lun                  = 0
    caching              = "ReadWrite"
    disk_size_gb         = 30
    storage_account_type = "Standard_LRS"
  }
]

# Encryption

keyvault_details = {
  kv_name         = "kv-ssp-0-nonprod-axso"
  kv_rg_name      = "axso-np-appl-ssp-test-rg"
}

# Extension

extension_config = {
    enable                    = false
    name                      = ""
    publisher                 = ""
    type                      = ""
    type_handler_version      = ""
    auto_upgrade_minor_version = true
    settings                  = {}
}
```

## variables.tf

```hcl
# Naming conventions - 

variable "project_name" {
  type        = string
  default     = "cloudinfra"
  description = "The name of the project. e.g. MDS, cloudinfra, cp, cpm etc.. etc.."
}

variable "subscription" {
  type        = string
  default     = "p"
  description = "The subscription type e.g. 'p' or 'np'"
}

variable "environment" {
  type        = string
  default     = "prod "
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "usecase" {
  type        = string
  default     = "buildagent"
  description = "The usecase. e.g. buildagent, webapp, db, etc.."
}

# VMSS properties

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Automation Account should be created."
}

variable "location" {
  type        = string
  description = "The location/region where the Automation Account should be created."
}

variable "linux_vmss_sku" {
  type        = string
  description = "(Required) Specifies the SKU of the image used to create the virtual machines."
}

variable "instances" {
  type        = number
  description = "(Optional) The number of Virtual Machines in the Scale Set. Defaults to 0"
}

variable "overprovision" {
  type        = bool
  description = "(Optional) Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You are not billed for these over-provisioned VMs and they do not count towards the Subscription Quota. Defaults to true"
}

variable "os_upgrade_mode" {
  type        = string
  description = "(Optional) Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual. Changing this forces a new resource to be created."
}

variable "availability_zones" {
  type        = list(number)
  description = "(Optional) Specifies a list of Availability Zones in which this Linux Virtual Machine Scale Set should be located."
}

variable "source_image_id" {
  type        = string
  description = "(Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image ID, Shared Image ID, Shared Image Version ID, Community Gallery Image ID, Community Gallery Image Version ID, Shared Gallery Image ID and Shared Gallery Image Version ID."
  default     = null
}

# VMSS Network

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of DNS Server IP addresses for the Virtual Network where the Virtual Machine Scale Set should be deployed."
}

variable "vmss_subnet" {
  description = "The details of the subnet for the Private Endpoint."
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
}

# VMSS Authentication

variable "admin_username" {
  type        = string
  default     = "adminuser"
  description = "(Required) The username of the local administrator on each Virtual Machine Scale Set instance. Changing this forces a new resource to be created."
}

variable "generate_admin_ssh_key" {
  type        = bool
  description = "Generates a secure private key and encodes it as PEM."
  default     = true
}

variable "admin_ssh_key_data" {
  type        = string
  description = "specify the path to the existing ssh key to authenciate linux vm"
  default     = ""
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The type of Identity to use for the Automation Account."
}

variable "managed_identities" {
  description = "List of maps containing user-assigned managed identities and their resource groups"
  type = list(object({
    name                = string
    resource_group_name = string
  }))
  default = []
}

# VMSS Image

variable "source_image" {
  description = "The source image to use for the VMSS"
  type        = map(string)

  default = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
}

# VMSS Disk

variable "os_disk_config" {
  description = "The configuration of the OS Disk for the Virtual Machine Scale Set"
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = number
  })
}

variable "enable_data_disk" {
  type        = bool
  description = "(Optional) Should Data Disks be enabled for this Virtual Machine Scale Set? Defaults to false"
}

variable "data_disks" {
  description = "List of maps containing data disk details"
  type = list(object({
    #name                 = string
    lun                  = number
    caching              = string
    disk_size_gb         = number
    storage_account_type = string
  }))
}

# Encryption

variable "keyvault_details" {
  type = object({
    kv_name    = string
    kv_rg_name = string
  })
  description = "The Key Vault details."
}

# Extension

variable "extension_config" {
  type = object({
    enable                    = bool
    name                      = string
    publisher                 = string
    type                      = string
    type_handler_version      = string
    auto_upgrade_minor_version = bool
    settings                  = map(any) # or object() if the settings are structured
  })

  default = {
    enable                    = false
    name                      = ""
    publisher                 = ""
    type                      = ""
    type_handler_version      = ""
    auto_upgrade_minor_version = true
    settings                  = {}
  }
}
```
## main.tf

```hcl
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.8.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

----------------------------

# Input Description

<!-- BEGIN_TF_DOCS -->
### main.tf

```hcl
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.8.0"
    }
  }
}

provider "azurerm" {
  features {}
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
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.disk_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_key.key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.admin_ssh_private_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.admin_ssh_public_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine_scale_set.linux_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_role_assignment.kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_string.string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.rsa](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ssh_key_data"></a> [admin\_ssh\_key\_data](#input\_admin\_ssh\_key\_data) | specify the path to the existing ssh key to authenciate linux vm | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required) The username of the local administrator on each Virtual Machine Scale Set instance. Changing this forces a new resource to be created. | `string` | `"adminuser"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (Optional) Specifies a list of Availability Zones in which this Linux Virtual Machine Scale Set should be located. | `list(number)` | `null` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | List of maps containing data disk details | <pre>list(object({<br>    #name                 = string<br>    lun                  = number<br>    caching              = string<br>    disk_size_gb         = number<br>    storage_account_type = string<br>  }))</pre> | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of DNS Server IP addresses for the Virtual Network where the Virtual Machine Scale Set should be deployed. | `list(string)` | `[]` | no |
| <a name="input_enable_data_disk"></a> [enable\_data\_disk](#input\_enable\_data\_disk) | (Optional) Should Data Disks be enabled for this Virtual Machine Scale Set? Defaults to false | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_extension_config"></a> [extension\_config](#input\_extension\_config) | n/a | <pre>object({<br>    enable                    = bool<br>    name                      = string<br>    publisher                 = string<br>    type                      = string<br>    type_handler_version      = string<br>    auto_upgrade_minor_version = bool<br>    settings                  = map(any) # or object() if the settings are structured<br>  })</pre> | <pre>{<br>  "auto_upgrade_minor_version": true,<br>  "enable": false,<br>  "name": "",<br>  "publisher": "",<br>  "settings": {},<br>  "type": "",<br>  "type_handler_version": ""<br>}</pre> | no |
| <a name="input_generate_admin_ssh_key"></a> [generate\_admin\_ssh\_key](#input\_generate\_admin\_ssh\_key) | Generates a secure private key and encodes it as PEM. | `bool` | `true` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of Identity to use for the Automation Account. | `string` | n/a | yes |
| <a name="input_instances"></a> [instances](#input\_instances) | (Optional) The number of Virtual Machines in the Scale Set. Defaults to 0 | `number` | n/a | yes |
| <a name="input_keyvault_details"></a> [keyvault\_details](#input\_keyvault\_details) | The Key Vault details. | <pre>object({<br>    kv_name    = string<br>    kv_rg_name = string<br>  })</pre> | n/a | yes |
| <a name="input_linux_vmss_sku"></a> [linux\_vmss\_sku](#input\_linux\_vmss\_sku) | (Required) Specifies the SKU of the image used to create the virtual machines. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the Automation Account should be created. | `string` | n/a | yes |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | List of maps containing user-assigned managed identities and their resource groups | <pre>list(object({<br>    name                = string<br>    resource_group_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_os_disk_config"></a> [os\_disk\_config](#input\_os\_disk\_config) | The configuration of the OS Disk for the Virtual Machine Scale Set | <pre>object({<br>    caching              = string<br>    storage_account_type = string<br>    disk_size_gb         = number<br>  })</pre> | n/a | yes |
| <a name="input_os_flavor"></a> [os\_flavor](#input\_os\_flavor) | Specify the flavour of the operating system image to deploy VMSS. Valid values are `windows` and `linux` | `string` | `"linux"` | no |
| <a name="input_os_upgrade_mode"></a> [os\_upgrade\_mode](#input\_os\_upgrade\_mode) | (Optional) Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_overprovision"></a> [overprovision](#input\_overprovision) | (Optional) Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You are not billed for these over-provisioned VMs and they do not count towards the Subscription Quota. Defaults to true | `bool` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, cloudinfra, cp, cpm etc.. etc.. | `string` | `"cloudinfra"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Automation Account should be created. | `string` | n/a | yes |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | The source image to use for the VMSS | `map(string)` | <pre>{<br>  "offer": "debian-10",<br>  "publisher": "Debian",<br>  "sku": "10",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | (Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image ID, Shared Image ID, Shared Image Version ID, Community Gallery Image ID, Community Gallery Image Version ID, Shared Gallery Image ID and Shared Gallery Image Version ID. | `string` | `null` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_usecase"></a> [usecase](#input\_usecase) | The usecase. e.g. buildagent, webapp, db, etc.. | `string` | `"buildagent"` | no |
| <a name="input_vmss_subnet"></a> [vmss\_subnet](#input\_vmss\_subnet) | The details of the subnet for the Private Endpoint. | <pre>object({<br>    subnet_name  = string<br>    vnet_name    = string<br>    vnet_rg_name = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->