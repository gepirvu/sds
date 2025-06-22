variable "project_name" {
  type        = string
  default     = "etools"
  description = "The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.."
}

variable "subscription" {
  type        = string
  default     = "p"
  description = "The subscription type e.g. 'p' or 'np'"
}

variable "environment" {
  type        = string
  default     = "prod "
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "resource_group_name" {
  type        = string
  default     = "axso-np-appl-<project-name>-<environment>-rg"
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "west europe"
  description = "(Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
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

variable "monitor_workspace_public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the public network access should be enabled for the Azure Monitor Workspace."

}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable  private endpoint."
}

variable "api_key_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the API key should be enabled for the Grafana instance."
}

variable "grafana_major_version" {
  type        = string
  default     = "10"
  description = "The major version of Grafana to use. Possible values are 9 and 10."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Grafana instance. Possible values are Essential and Standard."

}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether zone redundancy should be enabled for the Grafana instance."
}

variable "deterministic_outbound_ip_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the deterministic outbound IP should be enabled for the Grafana instance. Only use it in case you cant use private connection to the datasources."

}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The identity type for the Grafana instance. Possible values are SystemAssigned and UserAssigned. UserAssigned is not supported yet."

}

variable "azure_monitor_workspace_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether the Azure Monitor Workspace should be enabled for the Grafana instance."

}

variable "smtp_enable" {
  type        = bool
  default     = false
  description = "Indicates whether the SMTP should be enabled for the Grafana instance."

}


variable "admin_groups" {
  type        = list(string)
  default     = []
  description = "The list of admin groups for the Grafana instance."

}

variable "editor_groups" {
  type        = list(string)
  default     = []
  description = "The list of editor groups for the Grafana instance."

}

variable "viewer_groups" {
  type        = list(string)
  default     = []
  description = "The list of viewer groups for the Grafana instance."

}