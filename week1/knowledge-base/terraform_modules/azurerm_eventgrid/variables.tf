
variable "subscription" {
  type        = string
  description = "The Axso environment subscription e.g. 'p' for production or 'np' for non-production"
  default     = "np"
}

variable "project_name" {
  type        = string
  description = "The Axso project name e.g. 'etools'"
  default     = "etools"
}

variable "environment" {
  type        = string
  description = "The Axso environment e.g. 'dev', 'test', 'prod'"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group will be created"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure resources."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network for the Azure resources."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Vnet resource group name"
}

variable "pe_subnet_name" {
  type        = string
  description = "Private endpoints subnet id"
}

variable "eventgrid_domain_config" {
  type = list(object({
    eventgrid_domain_purpose = string
    event_schema             = string
    system_assigned_identity = bool
    topics = list(object({
      topic_name = string
      subscriptions = list(object({
        webhooks = list(object({
          subscription_name                       = string
          url                                     = string
          max_events_per_batch                    = number
          preferred_batch_size_in_kilobytes       = number
          active_directory_tenant_id              = string
          active_directory_app_id_or_uri          = string
          dead_letter_identity_type               = string
          dead_letter_user_assigned_identity      = string
          dead_letter_storage_account_id          = string
          dead_letter_storage_blob_container_name = string
          subject_filters = list(object({
            subject_begins_with = string
            subject_ends_with   = string
            case_sensitive      = bool
          }))
          advanced_filters = list(object({
            bool_equals                   = list(object({ key = string, value = bool }))
            number_greater_than           = list(object({ key = string, value = number }))
            number_greater_than_or_equals = list(object({ key = string, value = number }))
            number_less_than              = list(object({ key = string, value = number }))
            number_less_than_or_equals    = list(object({ key = string, value = number }))
            number_in                     = list(object({ key = string, values = list(number) }))
            number_not_in                 = list(object({ key = string, values = list(number) }))
            number_in_range               = list(object({ key = string, values = list(number) }))
            number_not_in_range           = list(object({ key = string, values = list(number) }))
            string_begins_with            = list(object({ key = string, values = list(string) }))
            string_not_begins_with        = list(object({ key = string, values = list(string) }))
            string_ends_with              = list(object({ key = string, values = list(string) }))
            string_not_ends_with          = list(object({ key = string, values = list(string) }))
            string_contains               = list(object({ key = string, values = list(string) }))
            string_not_contains           = list(object({ key = string, values = list(string) }))
            string_in                     = list(object({ key = string, values = list(string) }))
            string_not_in                 = list(object({ key = string, values = list(string) }))
            is_not_null                   = list(object({ key = string }))
            is_null_or_undefined          = list(object({ key = string }))
          }))
        }))
        storage_queues = list(object({
          storage_account_id                      = string
          queue_name                              = string
          queue_message_time_to_live_in_seconds   = number
          dead_letter_identity_type               = string
          dead_letter_user_assigned_identity      = string
          dead_letter_storage_account_id          = string
          dead_letter_storage_blob_container_name = string
          subject_filters = list(object({
            subject_begins_with = string
            subject_ends_with   = string
            case_sensitive      = bool
          }))
          advanced_filters = list(object({
            bool_equals                   = list(object({ key = string, value = bool }))
            number_greater_than           = list(object({ key = string, value = number }))
            number_greater_than_or_equals = list(object({ key = string, value = number }))
            number_less_than              = list(object({ key = string, value = number }))
            number_less_than_or_equals    = list(object({ key = string, value = number }))
            number_in                     = list(object({ key = string, values = list(number) }))
            number_not_in                 = list(object({ key = string, values = list(number) }))
            number_in_range               = list(object({ key = string, values = list(number) }))
            number_not_in_range           = list(object({ key = string, values = list(number) }))
            string_begins_with            = list(object({ key = string, values = list(string) }))
            string_not_begins_with        = list(object({ key = string, values = list(string) }))
            string_ends_with              = list(object({ key = string, values = list(string) }))
            string_not_ends_with          = list(object({ key = string, values = list(string) }))
            string_contains               = list(object({ key = string, values = list(string) }))
            string_not_contains           = list(object({ key = string, values = list(string) }))
            string_in                     = list(object({ key = string, values = list(string) }))
            string_not_in                 = list(object({ key = string, values = list(string) }))
            is_not_null                   = list(object({ key = string }))
            is_null_or_undefined          = list(object({ key = string }))
          }))
        }))
      }))
    }))
  }))
  description = "Eventgrid domain configuration."
}
