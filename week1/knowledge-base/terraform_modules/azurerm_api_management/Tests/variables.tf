variable "location" {
  type        = string
  description = "The default location where the resource will be created"
  default     = "westeurope"
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
  description = "The name of the network security group."
}

variable "key_vault_name" {
  description = "Name of the Key Vault where the secrets are read"
  type        = string
  default     = null
}

variable "named_values" {
  description = "(Optional)Map containing the name of the named values as key and value as values"
  type        = list(map(string))
  default     = []
}

variable "keyvault_named_values" {
  description = "(Optional)Map containing the name of the named values as key and value as values. The secret is stored in keyvault"
  type        = list(map(string))
  default     = []
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

variable "zones" {
  type        = list(number)
  description = "(Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier."
  default     = [1, 2, 3]
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
  default     = "mario.martinezdiez@axpo.com"
}

variable "app_insights_name" {
  type        = string
  default     = null
  description = "(Optional)In case you want to integrate APIM with application insights please specify name"
}

variable "backend_protocol" {
  type        = string
  default     = "http"
  description = "Protocol for the backend http or soap"
}


variable "backend_services" {
  type        = list(string)
  description = "(Optional)Include backend setting in case are needed"
  default     = []
}

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
  description = "(Optional)Name for the gateway URL"
  default     = null
}
