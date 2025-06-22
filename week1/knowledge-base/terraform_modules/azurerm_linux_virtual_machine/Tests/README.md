# Infra Team Test

This template deploys a Resource Group, a vnet, a subnet, a keyvault and a virtual machine
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
| <a name="module_vm"></a> [vm](#module\_vm) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_virtual_machine | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault | `string` | `"kv"` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the core network will be created | `string` | `"westeurope"` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | (Required) The name of the virtual network resource group name in which to create the Application Gateway. | `string` | `"vnet-test"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the core network will be created | `string` | `"rg"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the Subnet in which create the Virtual Machine. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network | `string` | `"vnet"` | no |
| <a name="input_vm_config"></a> [vm\_config](#input\_vm\_config) | List of subnet configurations. | <pre>list(object({<br/>    vm_size             = string<br/>    resource_group_name = optional(string)<br/>    admin_username      = optional(string)<br/>    vm_number           = optional(string)<br/>    key_vault_id        = optional(string)<br/>    zone_id             = optional(number)<br/>    storage_data_disk_config = map(object({<br/>      name                 = optional(string)<br/>      create_option        = optional(string, "Empty")<br/>      disk_size_gb         = number<br/>      lun                  = optional(number)<br/>      caching              = optional(string, "ReadWrite")<br/>      storage_account_type = optional(string, "StandardSSD_ZRS")<br/>      source_resource_id   = optional(string)<br/>      extra_tags           = optional(map(string), {})<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_vm_image"></a> [vm\_image](#input\_vm\_image) | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined. | `map(string)` | <pre>{<br/>  "offer": "debian-10",<br/>  "publisher": "Debian",<br/>  "sku": "10",<br/>  "version": "latest"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->