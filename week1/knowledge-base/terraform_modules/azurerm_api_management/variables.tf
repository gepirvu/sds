variable "location" {
  type        = string
  description = "The default location where the resource will be created"
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

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}


variable "sku_name" {
  type        = string
  description = "String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity"
  default     = "Basic_1"
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
  default     = null
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
  default     = "mario.martinezdiez@axpo.com"
}

variable "additional_location" {
  type        = list(map(string))
  description = "List of the name of the Azure Region in which the API Management Service should be expanded to."
  default     = []
}

variable "zones" {
  type        = list(number)
  description = "(Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier."
  default     = [1, 2, 3]
}

variable "certificate_configuration" {
  type        = list(map(string))
  description = "List of certificate configurations"
  default     = []
}

variable "client_certificate_enabled" {
  type        = bool
  description = "(Optional) Enforce a client certificate to be presented on each request to the gateway? This is only supported when SKU type is `Consumption`."
  default     = false
}

variable "gateway_disabled" {
  type        = bool
  description = "(Optional) Disable the gateway in main region? This is only supported when `additional_location` is set."
  default     = false
}

variable "min_api_version" {
  type        = string
  description = "(Optional) The version which the control plane API calls to API Management service are limited with version equal to or newer than."
  default     = null
}

variable "enable_http2" {
  type        = bool
  description = "Should HTTP/2 be supported by the API Management Service?"
  default     = false
}

variable "management_hostname_configuration" {
  type        = list(map(string))
  description = "List of management hostname configurations"
  default     = []
}

variable "scm_hostname_configuration" {
  type        = list(map(string))
  description = "List of scm hostname configurations"
  default     = []
}

variable "proxy_hostname_configuration" {
  type        = list(map(string))
  description = "List of proxy hostname configurations"
  default     = []
}

variable "portal_hostname_configuration" {
  type        = list(map(string))
  description = "Legacy portal hostname configurations"
  default     = []
}

variable "developer_portal_hostname_configuration" {
  type        = list(map(string))
  description = "Developer portal hostname configurations"
  default     = []
}

variable "notification_sender_email" {
  type        = string
  description = "Email address from which the notification will be sent"
  default     = null
}

variable "policy_configuration" {
  type        = map(string)
  description = "Map of policy configuration"
  default     = {}
}

variable "enable_sign_in" {
  type        = bool
  description = "Should anonymous users be redirected to the sign in page?"
  default     = false
}

variable "enable_sign_up" {
  type        = bool
  description = "Can users sign up on the development portal?"
  default     = false
}

variable "terms_of_service_configuration" {
  type        = list(map(string))
  description = "Map of terms of service configuration"

  default = [{
    consent_required = false
    enabled          = false
    text             = ""
  }]
}

variable "security_configuration" {
  type        = map(string)
  description = "Map of security configuration"
  default     = {}
}

### NETWORKING

variable "virtual_network_type" {
  type        = string
  description = "The type of virtual network you want to use, valid values include: None, External, Internal."
  default     = "Internal"
}
variable "subnet_names" {
  type        = list(string)
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

variable "nsg_name" {
  type        = string
  description = "NSG name of the subnet hosting the APIM to add the rule to allow management if the APIM is private"
  default     = null
}

variable "nsg_rg_name" {
  type        = string
  description = "Name of the RG hosting the NSG if it's different from the one hosting the APIM"
  default     = null
}

variable "create_management_rule" {
  type        = bool
  description = "Whether to create the NSG rule for the management port of the APIM. If true, nsg_name variable must be set"
  default     = true
}

variable "management_nsg_rule_priority" {
  type        = number
  description = "Priority of the NSG rule created for the management port of the APIM"
  default     = 101
}

### IDENTITY

variable "identity_type" {
  description = "Type of Managed Service Identity that should be configured on this API Management Service"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "A list of IDs for User Assigned Managed Identity resources to be assigned. This is required when type is set to UserAssigned or SystemAssigned, UserAssigned."
  type        = list(string)
  default     = []
}

variable "named_values" {
  description = "Map containing the name of the named values as key and value as values"
  type        = list(map(string))
  default     = []
}

variable "keyvault_named_values" {
  description = "Map containing the name of the named values as key and value as values. The secret is stored in keyvault"
  type        = list(map(string))
  default     = []
}

variable "key_vault_name" {
  description = "Name of the Key Vault where the secrets are read"
  type        = string
  default     = null
}

### NAMING

variable "custom_management_rule_name" {
  description = "Custom NSG rule name for APIM Management."
  type        = string
  default     = "default-management-apim-rule"
}

### LOGGING

# Diag settings / logs parameters

variable "app_insights_name" {
  type        = string
  description = "(Optional)In case you want to integrate APIM with application insights please specify name"
  default     = null
}

variable "backend_protocol" {
  type        = string
  default     = "http"
  description = "Protocol for the backend http or soap"
}

variable "backend_services" {
  type        = list(string)
  description = "Include backend setting in case are needed"
}


##CUSTOM DOMAIN
variable "requires_custom_host_name_configuration" {
  type        = bool
  description = "If APIM requires custom hostname configuration"
  default     = false
}


variable "wildcard_certificate_key_vault_name" {
  type        = string
  description = "(Optional)Name of the keyvault containing the certificate"
  default     = null
}

variable "wildcard_certificate_name" {
  type        = string
  description = "(Optional)Name of the certificate"
  default     = null
}

variable "wildcard_certificate_key_vault_resource_group_name" {
  type        = string
  description = "(Optional)Resource group containing certificate keyvault"
  default     = null
}


variable "developer_portal_host_name" {
  type        = string
  description = "(Optional)Name for the developers portal URL"
  default     = null
}

variable "management_host_name" {
  type        = string
  description = "(Optional)Name for the management portal URL"
  default     = null
}


variable "gateway_host_name" {
  type        = string
  description = "(Optional) Name for the gateway URL"
  default     = null
}