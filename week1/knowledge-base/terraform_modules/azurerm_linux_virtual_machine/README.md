| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_linux_virtual_machine?repoName=azurerm_linux_virtual_machine&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2467&repoName=azurerm_linux_virtual_machine&branchName=main) | **v1.6.7** | 24/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Linux Virtual Machine Configuration](#linux-virtual-machine-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Linux Virtual Machine Configuration

----------------------------

[Learn more about Linux Virtual Machine in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure virtual machines (VMs) are one of several types of on-demand, scalable computing resources that Azure offers. Typically, you choose a virtual machine when you need more control over the computing environment than the other choices offer.

This module deploys a Azure Linux Virtual Machine

These all resources will be deployed when using Linux Virtual Machine module.

- azurerm_managed_disk
- azurerm_disk_encryption_set
- azurerm_key_vault_key
- azurerm_virtual_machine_extension
- azurerm_network_interface
- azurerm_linux_virtual_machine

## Pre-requisites

----------------

- Resource Group
- Virtual Network
- Subnet
- Log Analytics Workspace (Optional)
- Keyvault to store disk encryption keys

> **Note:**
>
>Your SPI needs to have access to the Key Vault to store the admin user and password for your VM.
>
> - RBAC <https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli>
> - Access policy <https://learn.microsoft.com/en-us/azure/key-vault/general/assign-access-policy?tabs=azure-portal>

# Terraform Files

----------------------------

## module.tf

```hcl

module "vm" {
  for_each                    = { for each in var.vm_config : each.vm_number => each }
  source                      = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_virtual_machine?ref=v1.6.7"
  subscription                = var.subscription
  project_name                = var.project_name
  environment                 = var.environment
  resource_group_name         = var.resource_group_name
  location                    = var.location
  vm_image                    = var.vm_image
  virtual_network_name        = var.virtual_network_name
  network_resource_group_name = var.network_resource_group_name
  subnet_name                 = var.subnet_name
  vm_size                     = each.value.vm_size
  vm_number                   = each.value.vm_number
  admin_username              = each.value.admin_username
  storage_data_disk_config    = each.value.storage_data_disk_config
  key_vault_name              = var.key_vault_name
  zone_id                     = each.value.zone_id
}

```

## module.tf.tfvars  

```hcl

subscription = "np"
project_name = "prj"
environment  = "dev"
location     = "westeurope"
vm_image = {
  publisher = "Debian"
  offer     = "debian-10"
  sku       = "10"
  version   = "latest"
}

vm_config = [
  {
    vm_size        = "Standard_B2s_v2"
    admin_username = "tester"
    vm_number      = "001"
    zone_id        = 1
    storage_data_disk_config = {
      disk1 = {
        disk_size_gb = 64
      },
      disk2 = {
        disk_size_gb = 128
      }
      # Add more disks as needed
    }
  }
]


network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
resource_group_name         = "axso-np-appl-ssp-test-rg"
virtual_network_name        = "vnet-cloudinfra-nonprod-axso-e3og"
subnet_name                 = "compute"
key_vault_name              = "kv-ssp-0-nonprod-axso"


```

## variable.tf

```hcl

variable "location" {
  type        = string
  description = "The default location where the core network will be created"
  default     = "westeurope"
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
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

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined."
  type        = map(string)

  default = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
}

variable "vm_config" {
  description = "List of subnet configurations."
  type = list(object({
    vm_size             = string
    resource_group_name = optional(string)
    admin_username      = optional(string)
    vm_number           = optional(string)
    key_vault_id        = optional(string)
    zone_id             = optional(number)
    storage_data_disk_config = map(object({
      name                 = optional(string)
      create_option        = optional(string, "Empty")
      disk_size_gb         = number
      lun                  = optional(number)
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "StandardSSD_ZRS")
      source_resource_id   = optional(string)
      extra_tags           = optional(map(string), {})
    }))
  }))
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the core network will be created"
  default     = "rg"

}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network"
  default     = "vnet"

}

variable "subnet_name" {
  description = "Name of the Subnet in which create the Virtual Machine."
  type        = string
}

variable "network_resource_group_name" {
  type        = string
  description = "(Required) The name of the virtual network resource group name in which to create the Application Gateway."
  default     = "vnet-test"

}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault"
  default     = "kv"

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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.disk_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_access_policy.key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.vm_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.vm_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_role_assignment.role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.network_watcher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.omsagentlin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vmextensionlinux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [random_string.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Username for Virtual Machine administrator account. | `string` | n/a | yes |
| <a name="input_availability_set_id"></a> [availability\_set\_id](#input\_availability\_set\_id) | The ID of the Azure Availability Set to associate with the virtual machine, if applicable. | `string` | `null` | no |
| <a name="input_backup_policy_id"></a> [backup\_policy\_id](#input\_backup\_policy\_id) | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup). | `string` | `null` | no |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_diagnostics_storage_account_name"></a> [diagnostics\_storage\_account\_name](#input\_diagnostics\_storage\_account\_name) | The name of the Azure Storage Account to be used for diagnostics data, if applicable. If not provided, diagnostics data may not be stored in a dedicated storage account. | `string` | `null` | no |
| <a name="input_disk_encryption_volume_type"></a> [disk\_encryption\_volume\_type](#input\_disk\_encryption\_volume\_type) | n/a | `string` | `"All"` | no |
| <a name="input_enable_disk_encryption_extension"></a> [enable\_disk\_encryption\_extension](#input\_enable\_disk\_encryption\_extension) | set true if Vm requires oms\_agent extension configuration, otherwise false | `bool` | `false` | no |
| <a name="input_enable_network_watcher_extension"></a> [enable\_network\_watcher\_extension](#input\_enable\_network\_watcher\_extension) | set true if Vm requires network watcher extension configuration, otherwise false | `bool` | `false` | no |
| <a name="input_enable_oms_agent_extension"></a> [enable\_oms\_agent\_extension](#input\_enable\_oms\_agent\_extension) | set true if Vm requires oms\_agent extension configuration, otherwise false | `bool` | `false` | no |
| <a name="input_encrypt_operation"></a> [encrypt\_operation](#input\_encrypt\_operation) | n/a | `string` | `"EnableEncryption"` | no |
| <a name="input_encryption_algorithm"></a> [encryption\_algorithm](#input\_encryption\_algorithm) | Algo for encryption | `string` | `"RSA-OAEP"` | no |
| <a name="input_encryption_at_host_enabled"></a> [encryption\_at\_host\_enabled](#input\_encryption\_at\_host\_enabled) | Should Encryption at Host be enabled? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_encryption_key_url"></a> [encryption\_key\_url](#input\_encryption\_key\_url) | URL to encrypt Key | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity. | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the keyVault | `any` | `null` | no |
| <a name="input_keyvault_rbac"></a> [keyvault\_rbac](#input\_keyvault\_rbac) | True if the keyvault use rbac | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | log analytics workspace name | `string` | `null` | no |
| <a name="input_log_analytics_workspace_primary_shared_key"></a> [log\_analytics\_workspace\_primary\_shared\_key](#input\_log\_analytics\_workspace\_primary\_shared\_key) | log analytics workspace primary\_shared\_key | `string` | `""` | no |
| <a name="input_maintenance_configuration_ids"></a> [maintenance\_configuration\_ids](#input\_maintenance\_configuration\_ids) | List of maintenance configurations to attach to this VM. | `list(string)` | `[]` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | (Required) The name of the virtual network resource group name in which to create the Application Gateway. | `string` | `"vnet-test"` | no |
| <a name="input_network_watcher_type_handler_version"></a> [network\_watcher\_type\_handler\_version](#input\_network\_watcher\_type\_handler\_version) | network watcher extension type handler version | `string` | `"1.4"` | no |
| <a name="input_nic_enable_accelerated_networking"></a> [nic\_enable\_accelerated\_networking](#input\_nic\_enable\_accelerated\_networking) | Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| <a name="input_oms_agent_type_handler_version"></a> [oms\_agent\_type\_handler\_version](#input\_oms\_agent\_type\_handler\_version) | oms\_agent\_type\_handler\_version | `string` | `"1.12"` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | Specifies the caching requirements for the OS Disk. | `string` | `"ReadWrite"` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Specifies the size of the OS disk in gigabytes. | `string` | `null` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. | `string` | `"Premium_ZRS"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. Compatibility list is available here https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images. | `string` | `"ImageDefault"` | no |
| <a name="input_patching_reboot_setting"></a> [patching\_reboot\_setting](#input\_patching\_reboot\_setting) | Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`. | `string` | `"IfRequired"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_proximity_placement_group_id"></a> [proximity\_placement\_group\_id](#input\_proximity\_placement\_group\_id) | The ID of the Azure Proximity Placement Group to associate with the resources, if applicable. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the vm | `string` | n/a | yes |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | True to deploy VM as a Spot Instance | `bool` | `false` | no |
| <a name="input_spot_instance_eviction_policy"></a> [spot\_instance\_eviction\_policy](#input\_spot\_instance\_eviction\_policy) | Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created. | `string` | `"Deallocate"` | no |
| <a name="input_spot_instance_max_bid_price"></a> [spot\_instance\_max\_bid\_price](#input\_spot\_instance\_max\_bid\_price) | The maximum price you're willing to pay for this VM in US Dollars; must be greater than the current spot price. `-1` If you don't want the VM to be evicted for price reasons. | `number` | `-1` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | SSH private key. | `string` | `null` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key. | `string` | `null` | no |
| <a name="input_static_private_ip"></a> [static\_private\_ip](#input\_static\_private\_ip) | Static private IP. Private IP is dynamic if not set. | `string` | `null` | no |
| <a name="input_storage_data_disk_config"></a> [storage\_data\_disk\_config](#input\_storage\_data\_disk\_config) | Map of objects to configure storage data disk(s). | <pre>map(object({<br/>    create_option        = optional(string, "Empty")<br/>    disk_size_gb         = number<br/>    lun                  = optional(number)<br/>    caching              = optional(string, "ReadWrite")<br/>    storage_account_type = optional(string, "StandardSSD_ZRS")<br/>    source_resource_id   = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the Subnet in which create the Virtual Machine. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_type_handler_version"></a> [type\_handler\_version](#input\_type\_handler\_version) | Type handler version of the VM extension to use. Defaults to 2.2 on Windows and 1.1 on Linux | `string` | `""` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The Base64-Encoded User Data which should be used for this Virtual Machine. | `string` | `null` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the Virtual Network in which create the Virtual Machine. | `string` | n/a | yes |
| <a name="input_vm_image"></a> [vm\_image](#input\_vm\_image) | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined. | `map(string)` | <pre>{<br/>  "offer": "debian-10",<br/>  "publisher": "Debian",<br/>  "sku": "10",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_vm_image_id"></a> [vm\_image\_id](#input\_vm\_image\_id) | The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null. | `string` | `null` | no |
| <a name="input_vm_nic_number"></a> [vm\_nic\_number](#input\_vm\_nic\_number) | The virtual machine network interface card (NIC) number or identifier, e.g., '001'. | `string` | `"001"` | no |
| <a name="input_vm_number"></a> [vm\_number](#input\_vm\_number) | The virtual machine number or identifier, e.g., '001'. | `string` | `"001"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size (SKU) of the Virtual Machine to create. | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Index of the Availability Zone which the Virtual Machine should be allocated in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | ID of the Virtual Machine |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the Virtual Machine |
| <a name="output_vm_nic_id"></a> [vm\_nic\_id](#output\_vm\_nic\_id) | ID of the Network Interface Configuration attached to the Virtual Machine |
| <a name="output_vm_nic_name"></a> [vm\_nic\_name](#output\_vm\_nic\_name) | Name of the Network Interface Configuration attached to the Virtual Machine |
| <a name="output_vm_private_ip_address"></a> [vm\_private\_ip\_address](#output\_vm\_private\_ip\_address) | Private IP address of the Virtual Machine |
<!-- END_TF_DOCS -->
