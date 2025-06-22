#------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Global
#------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Namin conventions - 

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

# Resource ids in local

variable "vmss_subnet" {
  description = "The details of the subnet for the Private Endpoint."
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
}

variable "keyvault_details" {
  type = object({
    kv_name    = string
    kv_rg_name = string
  })
  description = "The Key Vault details."
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# VMSS
#------------------------------------------------------------------------------------------------------------------------------------------------------------------#

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
  default     = null
  description = "(Optional) Specifies a list of Availability Zones in which this Linux Virtual Machine Scale Set should be located."
}

variable "source_image_id" {
  type        = string
  description = "(Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image ID, Shared Image ID, Shared Image Version ID, Community Gallery Image ID, Community Gallery Image Version ID, Shared Gallery Image ID and Shared Gallery Image Version ID."
  default     = null
}

# VMSS Authentication - 

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

variable "os_flavor" {
  type        = string
  description = "Specify the flavour of the operating system image to deploy VMSS. Valid values are `windows` and `linux`"
  default     = "linux"
}

variable "admin_ssh_key_data" {
  type        = string
  description = "specify the path to the existing ssh key to authenciate linux vm"
  default     = ""
}

variable "identity_type" {
  type        = string
  description = "The type of Identity to use for the Automation Account."
}

variable "managed_identities" {
  description = "List of maps containing user-assigned managed identities and their resource groups"
  type = list(object({
    name                = string
    resource_group_name = string
  }))
}

# VMSS Image -

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

# VMSS Disk -

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

# VMSS Network -

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of DNS Server IP addresses for the Virtual Network where the Virtual Machine Scale Set should be deployed."
}

# VMSS Extension -

variable "extension_config" {
  type = object({
    enable                     = bool
    name                       = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    auto_upgrade_minor_version = bool
    settings                   = map(any) # or object() if the settings are structured
  })

  default = {
    enable                     = false
    name                       = ""
    publisher                  = ""
    type                       = ""
    type_handler_version       = ""
    auto_upgrade_minor_version = true
    settings                   = {}
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------#
