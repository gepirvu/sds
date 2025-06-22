variable "location" {
  type        = string
  description = "The default location where the core network will be created"
  default     = "westeurope"
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "kv_number" {
  type        = string
  description = "The use case of the keyvault, to be used in the name. e.g. 001, or 002"
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the key vault"
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are \"standard\" and \"premium\"."
  type        = string
  default     = "standard"
}

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "admin_groups" {
  description = "Name of the groups that can do all operations on all keys, secrets and certificates."
  type        = list(string)
  default     = []
}

variable "reader_groups" {
  description = "IDs of the objects that can read all keys, secrets and certificates."
  type        = list(string)
  default     = []
}

variable "public_network_access_enabled" {
  description = "Whether the Key Vault is available from public network."
  type        = bool
  default     = false
}

variable "network_acls" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. Set to `null` to disable. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more information."
  type = object({
    bypass                     = optional(string, "None"),
    default_action             = optional(string, "Deny"),
    ip_rules                   = optional(list(string)),
    virtual_network_subnet_ids = optional(list(string)),
  })
  default = {}
}

# Private endpoint (used in data block to get subnet ID)
variable "virtual_network_name" {
  type        = string
  description = "Virtual network name for the enviornment to enable private endpoint."
}

variable "pe_subnet_name" {
  type        = string
  description = "The subnet name, used in data source to get subnet ID, to enable the private endpoint."
}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable  private endpoint."
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` days."
  type        = number
  default     = 7
}

variable "expire_notification" {
  description = "Send a notification before the secret expires"
  type        = bool
  default     = true

}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace to send diagnostic logs to."
  type        = string
  default     = null
}

variable "email_receiver" {
  description = "List of email receivers of secret expire notification."
  type        = list(string)
  default     = []
}

variable "webhook_receiver" {
  type = list(object({
    name        = string,
    service_uri = string
  }))
  default = []

}