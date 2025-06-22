# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

## Notes

Any notes or comments for the Infra team can be added here. (Please add any notes or comments with a date DD/MM/YYYY)

## Terraform Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.14.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azurerm_eventgrid_domains"></a> [azurerm\_eventgrid\_domains](#module\_azurerm\_eventgrid\_domains) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_eventgrid | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The Axso environment e.g. 'dev', 'test', 'prod' | `string` | `"dev"` | no |
| <a name="input_eventgrid_domain_config"></a> [eventgrid\_domain\_config](#input\_eventgrid\_domain\_config) | Eventgrid domain configuration. | <pre>list(object({<br/>    eventgrid_domain_purpose = string<br/>    event_schema             = string<br/>    system_assigned_identity = bool<br/>    topics = list(object({<br/>      topic_name = string<br/>      subscriptions = list(object({<br/>        webhooks = list(object({<br/>          subscription_name                       = string<br/>          url                                     = string<br/>          max_events_per_batch                    = number<br/>          preferred_batch_size_in_kilobytes       = number<br/>          active_directory_tenant_id              = string<br/>          active_directory_app_id_or_uri          = string<br/>          dead_letter_identity_type               = string<br/>          dead_letter_user_assigned_identity      = string<br/>          dead_letter_storage_account_id          = string<br/>          dead_letter_storage_blob_container_name = string<br/>          subject_filters = list(object({<br/>            subject_begins_with = string<br/>            subject_ends_with   = string<br/>            case_sensitive      = bool<br/>          }))<br/>          advanced_filters = list(object({<br/>            bool_equals                   = list(object({ key = string, value = bool }))<br/>            number_greater_than           = list(object({ key = string, value = number }))<br/>            number_greater_than_or_equals = list(object({ key = string, value = number }))<br/>            number_less_than              = list(object({ key = string, value = number }))<br/>            number_less_than_or_equals    = list(object({ key = string, value = number }))<br/>            number_in                     = list(object({ key = string, values = list(number) }))<br/>            number_not_in                 = list(object({ key = string, values = list(number) }))<br/>            number_in_range               = list(object({ key = string, values = list(number) }))<br/>            number_not_in_range           = list(object({ key = string, values = list(number) }))<br/>            string_begins_with            = list(object({ key = string, values = list(string) }))<br/>            string_not_begins_with        = list(object({ key = string, values = list(string) }))<br/>            string_ends_with              = list(object({ key = string, values = list(string) }))<br/>            string_not_ends_with          = list(object({ key = string, values = list(string) }))<br/>            string_contains               = list(object({ key = string, values = list(string) }))<br/>            string_not_contains           = list(object({ key = string, values = list(string) }))<br/>            string_in                     = list(object({ key = string, values = list(string) }))<br/>            string_not_in                 = list(object({ key = string, values = list(string) }))<br/>            is_not_null                   = list(object({ key = string }))<br/>            is_null_or_undefined          = list(object({ key = string }))<br/>          }))<br/>        }))<br/>        storage_queues = list(object({<br/>          storage_account_id                      = string<br/>          queue_name                              = string<br/>          queue_message_time_to_live_in_seconds   = number<br/>          dead_letter_identity_type               = string<br/>          dead_letter_user_assigned_identity      = string<br/>          dead_letter_storage_account_id          = string<br/>          dead_letter_storage_blob_container_name = string<br/>          subject_filters = list(object({<br/>            subject_begins_with = string<br/>            subject_ends_with   = string<br/>            case_sensitive      = bool<br/>          }))<br/>          advanced_filters = list(object({<br/>            bool_equals                   = list(object({ key = string, value = bool }))<br/>            number_greater_than           = list(object({ key = string, value = number }))<br/>            number_greater_than_or_equals = list(object({ key = string, value = number }))<br/>            number_less_than              = list(object({ key = string, value = number }))<br/>            number_less_than_or_equals    = list(object({ key = string, value = number }))<br/>            number_in                     = list(object({ key = string, values = list(number) }))<br/>            number_not_in                 = list(object({ key = string, values = list(number) }))<br/>            number_in_range               = list(object({ key = string, values = list(number) }))<br/>            number_not_in_range           = list(object({ key = string, values = list(number) }))<br/>            string_begins_with            = list(object({ key = string, values = list(string) }))<br/>            string_not_begins_with        = list(object({ key = string, values = list(string) }))<br/>            string_ends_with              = list(object({ key = string, values = list(string) }))<br/>            string_not_ends_with          = list(object({ key = string, values = list(string) }))<br/>            string_contains               = list(object({ key = string, values = list(string) }))<br/>            string_not_contains           = list(object({ key = string, values = list(string) }))<br/>            string_in                     = list(object({ key = string, values = list(string) }))<br/>            string_not_in                 = list(object({ key = string, values = list(string) }))<br/>            is_not_null                   = list(object({ key = string }))<br/>            is_null_or_undefined          = list(object({ key = string }))<br/>          }))<br/>        }))<br/>      }))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resource group will be created | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | Private endpoints subnet name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The Axso project name e.g. 'etools' | `string` | `"etools"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Azure resources. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The Axso environment subscription e.g. 'p' for production or 'np' for non-production | `string` | `"np"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network for the Azure resources. | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Vnet resource group name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->