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

variable "name" {
  type        = string
  description = "(Required) The name of WAF Or App GW to create."
  default     = "test"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Application Gateway."
  default     = "rg-test"

}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the virtual network."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) The name of the virtual network in which to create the Application Gateway."
  default     = "vnet-test"

}

variable "vint_subnet_name" {
  type    = string
  default = "Subnet name for Integrating in Webapps"
}


variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the Key Vault in which to create the Application Gateway."
  default     = "kv-test"

}

variable "frontend_ip_private" {
  type        = string
  description = "The private IP address for the Application Gateway frontend."
}

variable "frontend_port" {
  type        = list(string)
  description = "(Required) The frontend ports used by the listener."
}

variable "key_vault_rbac" {
  type        = bool
  description = "Whether to enable RBAC for the Key Vault."
}

variable "appgw_public" {
  type        = bool
  description = "Whether the Application Gateway should have public exposure."
}

variable "backend_address_pools" {
  type = list(object({
    name  = string
    ip    = list(string)
    fqdns = list(string)
  }))
  description = "(Required) The backend address pools for the Application Gateway."
}

variable "backend_http_settings" {
  type = list(object({
    cookie_based_affinity           = string
    name                            = string
    path                            = string
    port                            = number
    protocol                        = string
    request_timeout                 = number
    host_name                       = string
    probe_name                      = string
    connection_draining_enabled     = bool
    connection_draining_timeout_sec = number
    pick_hostname                   = bool
  }))
  description = "(Required) The backend HTTP settings for the Application Gateway."
}

variable "http_listeners" {
  type = list(object({
    name                 = string
    frontend_port_number = string
    protocol             = string
    ssl_certificate_name = string
    host_name            = string
    require_sni          = bool
  }))
  description = "(Required) The HTTP listeners for the Application Gateway."
}

variable "probes" {
  type = list(object({
    name                  = string
    interval              = number
    timeout               = number
    protocol              = string
    path                  = string
    unhealthy_threshold   = number
    match_status_code     = list(string)
    pick_hostname_backend = bool
    host                  = string
  }))
  description = "(Required) The probes for the Application Gateway."
}

variable "request_routing_rules" {
  type = list(object({
    name                        = string
    priority                    = number
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    rule_type                   = string
    url_path_map_name           = string
    redirect_configuration_name = string
  }))
  description = "(Required) The request routing rules for the Application Gateway."
}

variable "waf_enabled" {
  type        = bool
  description = "(Required) Whether to enable the Web Application Firewall (WAF)."
}

variable "waf_mode" {
  type        = string
  description = "(Required) The mode of the WAF. Possible values: 'Detection' or 'Prevention'."
}

variable "sku_name" {
  type        = string
  description = "(Required) The name of the SKU to use for the Application Gateway."
}

variable "sku_tier" {
  type        = string
  description = "(Required) The tier of the SKU to use for the Application Gateway."
}

variable "capacity_min" {
  type        = number
  description = "(Required) The minimum capacity of the Application Gateway."
}

variable "capacity_max" {
  type        = number
  description = "(Required) The maximum capacity of the Application Gateway."
}