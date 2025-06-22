variable "target_resource_id" {
  type        = string
  description = "The resource ID in which the target resource should be associated with"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "The Log Analytics Workspace name where the firewall logs will be created"
}

variable "logs" {
  type        = list(any)
  description = "Log Collection for Target Resource for example, Firewall, Key Vault etc."
  default     = []
}

variable "metrics" {
  type        = list(any)
  description = "Log Collection for Target Resource for example, Firewall, Key Vault etc."
  default     = []
}

variable "loga_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics was deployed."
}

variable "diagnostic_setting_name" {
  type        = string
  description = "Diagnostic setting name for the target resource"
}

variable "log_analytics_destination_type" {
  type        = string
  description = "(Optional) When set to 'Dedicated' logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}