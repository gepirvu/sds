variable "location" {
  type        = string
  description = "The default location where the core network will be created"
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

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the vm"
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

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault"
  default     = "kv"

}

variable "vm_config" {
  description = "List of Virtual Machine configurations."
  type = list(object({
    proximity_placement_group_id      = optional(string)
    availability_set_id               = optional(string)
    admin_username                    = string
    vm_number                         = string
    vm_nic_number                     = optional(string)
    diagnostics_storage_account_name  = optional(string)
    nic_enable_accelerated_networking = optional(bool)
    static_private_ip                 = optional(string)
    custom_data                       = optional(string)
    user_data                         = optional(string)
    vm_size                           = string
    zone_id                           = optional(number)
    os_disk_size_gb                   = optional(string)
    os_disk_storage_account_type      = optional(string)
    os_disk_caching                   = optional(string)
    identity = optional(object({
      type         = optional(string)
      identity_ids = optional(list(string))
    }))
    spot_instance                 = optional(bool)
    spot_instance_max_bid_price   = optional(number)
    spot_instance_eviction_policy = optional(string)
    backup_policy_id              = optional(string)
    enable_automatic_updates      = optional(bool)
    hotpatching_enabled           = optional(bool)
    patch_mode                    = optional(string)
    maintenance_configuration_ids = optional(list(string))
    patching_reboot_setting       = optional(string)
    storage_data_disk_config = optional(map(object({
      create_option        = optional(string)
      disk_size_gb         = optional(number)
      lun                  = optional(number)
      caching              = optional(string)
      storage_account_type = optional(string)
      source_resource_id   = optional(string)
    })))
    enable_antimalware_extension = optional(bool)
    antimalware_configuration = optional(object({
      name                                = optional(string)
      type_handler_version                = optional(string)
      iaas_antimalware_enabled            = optional(bool)
      iaas_antimalware_exclusions         = optional(string)
      iaas_antimalware_protection_enabled = optional(bool)
      iaas_antimalware_scan_settings      = optional(string)
    }))
    enable_oms_agent_extension                 = optional(bool)
    log_analytics_workspace_name               = optional(string)
    log_analytics_workspace_primary_shared_key = optional(string)
    oms_agent_type_handler_version             = optional(string)
    enable_network_watcher_extension           = optional(bool)
    network_watcher_type_handler_version       = optional(string)
    enable_disk_encryption_extension           = optional(bool)
    vm_os_type                                 = optional(string)
    key_vault_name                             = optional(string)
    keyvault_resource_group_name               = optional(string)
    encryption_key_url                         = optional(string)
    encryption_algorithm                       = optional(string)
    disk_encryption_volume_type                = optional(string)
    encrypt_operation                          = optional(string)
    type_handler_version                       = optional(string)

  }))
}



variable "subnet_name" {
  type        = string
  description = "The name of the subnet for the Azure resources."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network for the Azure resources."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the virtual network."
}