# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

## Notes

Any notes or comments for the Infra team can be added here. (Please add any notes or comments with a date DD/MM/YYYY)

## Terraform Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 4.8.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_axso_linux_vmss"></a> [axso\_linux\_vmss](#module\_axso\_linux\_vmss) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_virtual_machine_scale_set | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ssh_key_data"></a> [admin\_ssh\_key\_data](#input\_admin\_ssh\_key\_data) | specify the path to the existing ssh key to authenciate linux vm | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required) The username of the local administrator on each Virtual Machine Scale Set instance. Changing this forces a new resource to be created. | `string` | `"adminuser"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (Optional) Specifies a list of Availability Zones in which this Linux Virtual Machine Scale Set should be located. | `list(number)` | n/a | yes |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | List of maps containing data disk details | <pre>list(object({<br>    #name                 = string<br>    lun                  = number<br>    caching              = string<br>    disk_size_gb         = number<br>    storage_account_type = string<br>  }))</pre> | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of DNS Server IP addresses for the Virtual Network where the Virtual Machine Scale Set should be deployed. | `list(string)` | `[]` | no |
| <a name="input_enable_data_disk"></a> [enable\_data\_disk](#input\_enable\_data\_disk) | (Optional) Should Data Disks be enabled for this Virtual Machine Scale Set? Defaults to false | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_extension_config"></a> [extension\_config](#input\_extension\_config) | n/a | <pre>object({<br>    enable                    = bool<br>    name                      = string<br>    publisher                 = string<br>    type                      = string<br>    type_handler_version      = string<br>    auto_upgrade_minor_version = bool<br>    settings                  = map(any) # or object() if the settings are structured<br>  })</pre> | <pre>{<br>  "auto_upgrade_minor_version": true,<br>  "enable": false,<br>  "name": "",<br>  "publisher": "",<br>  "settings": {},<br>  "type": "",<br>  "type_handler_version": ""<br>}</pre> | no |
| <a name="input_generate_admin_ssh_key"></a> [generate\_admin\_ssh\_key](#input\_generate\_admin\_ssh\_key) | Generates a secure private key and encodes it as PEM. | `bool` | `true` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of Identity to use for the Automation Account. | `string` | `"SystemAssigned"` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | (Optional) The number of Virtual Machines in the Scale Set. Defaults to 0 | `number` | n/a | yes |
| <a name="input_keyvault_details"></a> [keyvault\_details](#input\_keyvault\_details) | The Key Vault details. | <pre>object({<br>    kv_name    = string<br>    kv_rg_name = string<br>  })</pre> | n/a | yes |
| <a name="input_linux_vmss_sku"></a> [linux\_vmss\_sku](#input\_linux\_vmss\_sku) | (Required) Specifies the SKU of the image used to create the virtual machines. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the Automation Account should be created. | `string` | n/a | yes |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | List of maps containing user-assigned managed identities and their resource groups | <pre>list(object({<br>    name                = string<br>    resource_group_name = string<br>  }))</pre> | `[]` | no |
| <a name="input_os_disk_config"></a> [os\_disk\_config](#input\_os\_disk\_config) | The configuration of the OS Disk for the Virtual Machine Scale Set | <pre>object({<br>    caching              = string<br>    storage_account_type = string<br>    disk_size_gb         = number<br>  })</pre> | n/a | yes |
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

No outputs.
<!-- END_TF_DOCS -->