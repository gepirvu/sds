variable "storage_accounts" {
  type = list(object({
    storage_account_index            = string,
    account_tier_storage             = string,
    access_tier_storage              = string,
    account_replication_type_storage = string,
    account_kind_storage             = string,
    public_network_access_enabled    = bool,
    nfsv3_enabled                    = bool,
    network_acl = object({
      bypass                     = optional(list(string), ["AzureServices"]),
      default_action             = optional(string, "Deny"),
      ip_rules                   = optional(list(string), []),
      virtual_network_subnet_ids = optional(list(string), [])
    }),
    is_hns_enabled               = bool,
    network_name                 = string, #private endpoint network name
    sa_subnet_name               = string, #private endpoint subnet name
    network_resource_group_name  = string, #private endpoint network resource group name
    delete_retention_policy_days = number,
    container_names              = list(string)
    identity_type                = string
    umids_names                  = list(string)
  }))
  default     = []
  description = "List of storage accounts to be created and the relevant properties."
}


variable "location" {
  type        = string
  description = "The default location where the Storage account will be created"
  default     = "westeurope"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault where the keys are stored"

}

