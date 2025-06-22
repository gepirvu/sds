# Infra Team Test

This template is used for testing the infra team's modules only.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm"></a> [vm](#module\_vm) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_windows_virtual_machine | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault | `string` | `"kv"` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the core network will be created | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the vm | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet for the Azure resources. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network for the Azure resources. | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group that contains the virtual network. | `string` | n/a | yes |
| <a name="input_vm_config"></a> [vm\_config](#input\_vm\_config) | List of Virtual Machine configurations. | <pre>list(object({<br/>    proximity_placement_group_id      = optional(string)<br/>    availability_set_id               = optional(string)<br/>    admin_username                    = string<br/>    vm_number                         = string<br/>    vm_nic_number                     = optional(string)<br/>    diagnostics_storage_account_name  = optional(string)<br/>    nic_enable_accelerated_networking = optional(bool)<br/>    static_private_ip                 = optional(string)<br/>    custom_data                       = optional(string)<br/>    user_data                         = optional(string)<br/>    vm_size                           = string<br/>    zone_id                           = optional(number)<br/>    os_disk_size_gb                   = optional(string)<br/>    os_disk_storage_account_type      = optional(string)<br/>    os_disk_caching                   = optional(string)<br/>    identity = optional(object({<br/>      type         = optional(string)<br/>      identity_ids = optional(list(string))<br/>    }))<br/>    spot_instance                 = optional(bool)<br/>    spot_instance_max_bid_price   = optional(number)<br/>    spot_instance_eviction_policy = optional(string)<br/>    backup_policy_id              = optional(string)<br/>    enable_automatic_updates      = optional(bool)<br/>    hotpatching_enabled           = optional(bool)<br/>    patch_mode                    = optional(string)<br/>    maintenance_configuration_ids = optional(list(string))<br/>    patching_reboot_setting       = optional(string)<br/>    storage_data_disk_config = optional(map(object({<br/>      create_option        = optional(string)<br/>      disk_size_gb         = optional(number)<br/>      lun                  = optional(number)<br/>      caching              = optional(string)<br/>      storage_account_type = optional(string)<br/>      source_resource_id   = optional(string)<br/>    })))<br/>    enable_antimalware_extension = optional(bool)<br/>    antimalware_configuration = optional(object({<br/>      name                                = optional(string)<br/>      type_handler_version                = optional(string)<br/>      iaas_antimalware_enabled            = optional(bool)<br/>      iaas_antimalware_exclusions         = optional(string)<br/>      iaas_antimalware_protection_enabled = optional(bool)<br/>      iaas_antimalware_scan_settings      = optional(string)<br/>    }))<br/>    enable_oms_agent_extension                 = optional(bool)<br/>    log_analytics_workspace_name               = optional(string)<br/>    log_analytics_workspace_primary_shared_key = optional(string)<br/>    oms_agent_type_handler_version             = optional(string)<br/>    enable_network_watcher_extension           = optional(bool)<br/>    network_watcher_type_handler_version       = optional(string)<br/>    enable_disk_encryption_extension           = optional(bool)<br/>    vm_os_type                                 = optional(string)<br/>    key_vault_name                             = optional(string)<br/>    keyvault_resource_group_name               = optional(string)<br/>    encryption_key_url                         = optional(string)<br/>    encryption_algorithm                       = optional(string)<br/>    disk_encryption_volume_type                = optional(string)<br/>    encrypt_operation                          = optional(string)<br/>    type_handler_version                       = optional(string)<br/><br/>  }))</pre> | n/a | yes |
| <a name="input_vm_image"></a> [vm\_image](#input\_vm\_image) | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined. | `map(string)` | <pre>{<br/>  "offer": "debian-10",<br/>  "publisher": "Debian",<br/>  "sku": "10",<br/>  "version": "latest"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->