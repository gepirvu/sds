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
  description = "The name of the resource group that contains the vm"
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "proximity_placement_group_id" {
  type        = string
  default     = null
  description = "The ID of the Azure Proximity Placement Group to associate with the resources, if applicable."
}

variable "availability_set_id" {
  type        = string
  default     = null
  description = "The ID of the Azure Availability Set to associate with the virtual machine, if applicable."
}

variable "admin_username" {
  description = "Username for Virtual Machine administrator account."
  type        = string
}

variable "key_vault_name" {
  description = "Name of the keyVault"
  default     = null
}

variable "keyvault_rbac" {
  description = "True if the keyvault use rbac"
  default     = true
}

variable "vm_number" {
  type        = string
  default     = "001"
  description = "The virtual machine number or identifier, e.g., '001'."
}

variable "vm_nic_number" {
  type        = string
  default     = "001"
  description = "The virtual machine network interface card (NIC) number or identifier, e.g., '001'."
}

variable "encryption_at_host_enabled" {
  description = "Should Encryption at Host be enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "diagnostics_storage_account_name" {
  type        = string
  default     = null
  description = "The name of the Azure Storage Account to be used for diagnostics data, if applicable. If not provided, diagnostics data may not be stored in a dedicated storage account."
}

### SSH Connection inputs
variable "ssh_public_key" {
  description = "SSH public key."
  type        = string
  default     = null
}

variable "ssh_private_key" {
  description = "SSH private key."
  type        = string
  default     = null
}

### Network inputs

variable "virtual_network_name" {
  description = "Name of the Virtual Network in which create the Virtual Machine."
  type        = string

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

variable "nic_enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to `false`."
  type        = bool
  default     = false
}

variable "static_private_ip" {
  description = "Static private IP. Private IP is dynamic if not set."
  type        = string
  default     = null
}

### VM inputs
variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The Base64-Encoded User Data which should be used for this Virtual Machine."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
}

variable "zone_id" {
  description = "Index of the Availability Zone which the Virtual Machine should be allocated in."
  type        = number
  default     = null
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

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Specifies the size of the OS disk in gigabytes."
  type        = string
  default     = null
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Premium_ZRS"
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

## Identity variables
variable "identity" {
  description = "Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

## Spot variables
variable "spot_instance" {
  description = "True to deploy VM as a Spot Instance"
  type        = bool
  default     = false
}

variable "spot_instance_max_bid_price" {
  description = "The maximum price you're willing to pay for this VM in US Dollars; must be greater than the current spot price. `-1` If you don't want the VM to be evicted for price reasons."
  type        = number
  default     = -1
}

variable "spot_instance_eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created."
  type        = string
  default     = "Deallocate"
}

## Backup variable
variable "backup_policy_id" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)."
  type        = string
  default     = null
}

## Patching variables
variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. Compatibility list is available here https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images."
  type        = string
  default     = "ImageDefault"
}

variable "maintenance_configuration_ids" {
  description = "List of maintenance configurations to attach to this VM."
  type        = list(string)
  default     = []
}

variable "patching_reboot_setting" {
  description = "Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`."
  type        = string
  default     = "IfRequired"
  nullable    = false
}


variable "storage_data_disk_config" {
  description = "Map of objects to configure storage data disk(s)."
  type = map(object({
    create_option        = optional(string, "Empty")
    disk_size_gb         = number
    lun                  = optional(number)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_ZRS")
    source_resource_id   = optional(string)
  }))
  default = {}
}

#-------------------------------------------------------------------------------------------------------------------------------
#_________________________ enable_oms_agent_extension _______________________________________                                     
#-------------------------------------------------------------------------------------------------------------------------------

variable "enable_oms_agent_extension" {
  type        = bool
  description = "set true if Vm requires oms_agent extension configuration, otherwise false"
  default     = false
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "log analytics workspace name"
  default     = null
}


variable "log_analytics_workspace_primary_shared_key" {
  type        = string
  description = "log analytics workspace primary_shared_key"
  default     = ""
}


variable "oms_agent_type_handler_version" {
  type        = string
  description = "oms_agent_type_handler_version"
  default     = "1.12"
}

variable "enable_network_watcher_extension" {
  type        = bool
  description = "set true if Vm requires network watcher extension configuration, otherwise false"
  default     = false
}

variable "network_watcher_type_handler_version" {
  default     = "1.4"
  description = "network watcher extension type handler version"
}

#-------------------------------------------------------------------------------------------------------------------------------
#_________________________  enable_disk_encryption_extension_______________________________________                                     
#-------------------------------------------------------------------------------------------------------------------------------


variable "enable_disk_encryption_extension" {
  type        = bool
  description = "set true if Vm requires oms_agent extension configuration, otherwise false"
  default     = false
}

variable "encryption_key_url" {
  description = "URL to encrypt Key"
  default     = ""
}

variable "encryption_algorithm" {
  description = " Algo for encryption"
  default     = "RSA-OAEP"
}

variable "disk_encryption_volume_type" {
  default = "All"
}

variable "encrypt_operation" {
  default = "EnableEncryption"
}

variable "type_handler_version" {
  description = "Type handler version of the VM extension to use. Defaults to 2.2 on Windows and 1.1 on Linux"
  default     = ""
}


