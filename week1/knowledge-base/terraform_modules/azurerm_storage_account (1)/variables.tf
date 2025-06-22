variable "location" {
  type        = string
  description = "The default location where the Storage account will be created"
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

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault where the keys are stored"

}

# Identity
variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "UserAssigned"
  validation {
    condition     = var.identity_type != null || var.identity_type == "" || var.identity_type == "SystemAssigned"
    error_message = "A valid identity_type must be provided. A minimum of one User Assigned Managed Identity must be provided."
  }
}

variable "umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the Storage Account"
  default     = []
}

variable "storage_account_index" {
  type        = string
  default     = "1"
  description = "Custom numbering of storage account to create. (Will be appended at the end of the name e.g. 'mdsdevsa1')"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "account_tier_storage" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. For FileStorage accounts only Premium is valid."
  default     = "Standard"
}

variable "access_tier_storage" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage, and StorageV2 accounts."
  default     = "Hot"
  validation {
    condition     = (var.access_tier_storage == "Hot" || var.access_tier_storage == "Cool") && (var.account_kind_storage == "BlobStorage" || var.account_kind_storage == "FileStorage" || var.account_kind_storage == "StorageV2")
    error_message = "Access tier must be set to 'Hot' or 'Cool' and is only valid for BlobStorage, FileStorage, and StorageV2 accounts."
  }
}



variable "nfsv3_enabled" {
  type        = bool
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false. This can only be true when account_tier is Standard and account_kind is StorageV2, or account_tier is Premium and account_kind is BlockBlobStorage. Additionally, the is_hns_enabled is true and account_replication_type must be LRS or RAGRS."
  default     = false

  validation {
    condition = !var.nfsv3_enabled || (
      var.nfsv3_enabled && (
        (
          var.account_tier_storage == "Standard" && var.account_kind_storage == "StorageV2"
          ) || (
          var.account_tier_storage == "Premium" && var.account_kind_storage == "BlockBlobStorage"
        )
        ) && var.is_hns_enabled == true && (
        var.account_replication_type_storage == "LRS" || var.account_replication_type_storage == "RAGRS"
      )
    )
    error_message = "NFSv3 can only be enabled when account_tier is Standard and account_kind is StorageV2, or account_tier is Premium and account_kind is BlockBlobStorage, with is_hns_enabled set to true, and replication type must be LRS or RAGRS."
  }
}


variable "account_replication_type_storage" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

variable "account_kind_storage" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to Storage. Only V2 storage account are supported with retention policy"
  default     = "StorageV2"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Controls whether data in the account may be accessed from public networks. Defaults to false."
  default     = false
}

variable "net_rules" {
  type = object({
    bypass                     = optional(list(string), ["AzureServices"]),
    default_action             = optional(string, "Deny"),
    ip_rules                   = optional(list(string), []),
    virtual_network_subnet_ids = optional(list(string), [])
  })
  description = "Specify network rules."
  default = {
    bypass         = ["AzureServices"]
    default_action = "Deny"
  }
}

variable "delete_retention_policy_days" {
  type        = number
  description = "Number of days to keep soft delete. Setting this to 0 turns it off."
}

variable "container_names" {
  type        = list(string)
  description = "Defines the name of the containers to be created in the specified storage account"
  default     = []
}

variable "is_hns_enabled" {
  type        = bool
  description = "Enable Hierarchical Namespace (HNS) for the storage account"

  validation {
    condition     = !var.is_hns_enabled || ((var.account_kind_storage == "BlockBlobStorage" && var.account_tier_storage == "Premium") || var.account_tier_storage == "Standard")
    error_message = "Hierarchical Namespace can only be enabled for BlockBlobStorage accounts with Premium tier or any account with Standard tier."
  }
}


# Private endpoint (used in data block to get subnet ID)
variable "network_name" {
  type        = string
  description = "Virtual network name for the enviornment to enable SA private endpoint."
}

variable "sa_subnet_name" {
  type        = string
  description = "The name for storage account subnet, used in data source to get subnet ID, to enable the storage account private endpoint."
}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable storage private endpoint."
}


