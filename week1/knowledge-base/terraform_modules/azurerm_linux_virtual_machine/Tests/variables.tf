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
