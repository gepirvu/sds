# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

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
| <a name="module_axso_data_factory"></a> [axso\_data\_factory](#module\_axso\_data\_factory) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_factory | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_integration_runtimes"></a> [azure\_integration\_runtimes](#input\_azure\_integration\_runtimes) | A list of Azure Integration Runtimes for Data Factory. | <pre>list(object({<br/>    name                    = string<br/>    description             = optional(string, null)<br/>    cleanup_enabled         = optional(bool, true)<br/>    compute_type            = optional(string, "General")<br/>    core_count              = optional(number, 8)<br/>    time_to_live_min        = optional(number, 0)<br/>    virtual_network_enabled = optional(bool, true)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cleanup_enabled": true,<br/>    "compute_type": "General",<br/>    "core_count": 8,<br/>    "description": "Integration Runtime 1",<br/>    "name": "runtime1",<br/>    "time_to_live_min": 0,<br/>    "virtual_network_enabled": false<br/>  }<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_global_parameters"></a> [global\_parameters](#input\_global\_parameters) | A list of global parameters to be created. | <pre>list(object({<br/>    name  = string<br/>    type  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the keyVault | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | (Optional) Specifies whether the Data Factory should be provisioned with a managed virtual network. Defaults to false. | `bool` | `false` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of the Purview account to associate with the Data Factory. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that contains the data factory | `string` | n/a | yes |
| <a name="input_self_hosted_integration_runtimes"></a> [self\_hosted\_integration\_runtimes](#input\_self\_hosted\_integration\_runtimes) | A list of Azure Integration Runtimes Self Hosted for Data Factory. | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "Integration Runtime 1",<br/>    "name": "runtime1"<br/>  }<br/>]</pre> | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_umids_names"></a> [umids\_names](#input\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the Data Factory. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |
| <a name="input_vsts_configuration"></a> [vsts\_configuration](#input\_vsts\_configuration) | VSTS configuration | <pre>object({<br/>    account_name = string<br/>    project_name = string<br/>    repository   = string<br/>    branch       = string<br/>    root_folder  = string<br/>    tenant_id    = string<br/>    service_id   = string<br/>    secret_id    = string<br/>  })</pre> | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->