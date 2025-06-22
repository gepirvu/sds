variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "project"
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

variable "key_vault_rbac" {
  type        = bool
  description = "extension tags"
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Product."
}


variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the virtual network."
}

variable "location" {
  type        = string
  description = "(Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new product to be created."
}

variable "private_ip_address_allocation" {
  type        = string
  description = "(Optional) Required if there are backend_address_pools and create_backend_nic is set to true. The allocation method used for the Private IP Address in the NIC Association with the Backend Address Pool (only if necessary). Possible values are Dynamic and Static. If Static then private_ip_address_nic_association (list of Static IPs) needs to be configured"
  default     = "Static"
}

variable "subnet_name" {
  type        = string
  description = "(Required) The name of the Subnet within which the WAF will be connected. Needs to be different from the name of the subnet in the subnet_id."
}

variable "vnet_name" {
  type        = string
  description = "(Required) The name of the Vnet within which the WAF will be connected."
}

variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the key vault who store the certificate."
}

variable "firewall_policy_id" {
  type        = string
  description = "(Optional) The ID of the Web Application Firewall Policy."
  default     = null
}

variable "private_ip" {
  type        = string
  description = "(Required) Not required only if frontend_config_private_ip_address_allocation is set to Dynamic. The Private IP Address to use for the Application Gateway."
}

variable "appgw_public" {
  type        = bool
  description = "(Required) Indicate if the Application gateway should have private or public exposure"
  default     = false
}


variable "frontend_port" {
  type        = list(string)
  description = "(Required) The frontend port used by the listener."
}


variable "backend_address_pools" {
  type = list(object({
    name  = string
    fqdns = list(string)
    ip    = list(string)
  }))
}


variable "backend_pools_associate_nics" {
  type = map(list(string))

  description = "(Optional) When you want to create a backend pool pointing directly to VM nics. Expects the backend pool with the `backend_name` property to already be created. The name of the map element should be the name of the backend."
  default     = {}
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
    trusted_root_certificate_names  = optional(list(string))
  }))
}

variable "certificates_load_type" {
  type        = string
  description = "(Optional) Upload method used for SSL and Trusted Root Certificates. Accepted values are Local or Keyvault."
  default     = "Keyvault"
}

variable "ssl_certificates_keyvault" {
  type = list(object({
    name                               = string
    key_vault_secret_or_certificate_id = string
  }))
  description = "(Optional) Only if ssl_certificates is not set and certificates_load_type is set to Keyvault. A list of ssl certificates with .pfx or .pem extension located in the keyvault as certificates (important: extract the secret id url from the **certificate**. Take note that it needs to be a Certificate, not a secret. This certificate in the keyvault has a Secret ID). It consists of a ==> name:The Name of the SSL certificate that is unique within this Application Gateway; key_vault_secret_or_certificate_id: Secret ID of the Keyvault Certificate that has the .pfx or .pem file."
  default     = []
}

variable "certificates_path" {
  type        = string
  description = "(Optional) Only if ssl_certificates is set (not the ssl_certificates_keyvault) and certificates_load_type is set to Local. Path where are located the certificates (both authentication_certificates and ssl certificates). Required if ssl_certificates is set."
  default     = ""
}
variable "trusted_root_certificates" {
  type = list(
    object({
      name        = string
      certificate = string
    })
  )
  description = "(Optional) List of objects taking the trusted root certificates in .crt extension for backend http settings"
  default     = []
}


variable "http_listeners" {
  type = list(object({
    name                 = string
    host_name            = optional(string)
    require_sni          = bool
    ssl_certificate_name = optional(string)
    protocol             = string
    frontend_port_number = string
  }))
}

variable "probes" {
  type = list(object({
    host                  = string
    interval              = number
    name                  = string
    protocol              = string
    path                  = string
    timeout               = number
    unhealthy_threshold   = number
    match_status_code     = list(string)
    pick_hostname_backend = bool
  }))
  default = []
}


variable "url_path_map" {
  type = list(object({
    name = string
    path_rule = list(
      object({
        name                        = string
        paths                       = list(string)
        backend_http_settings_name  = string
        backend_address_pool_name   = string
        redirect_configuration_name = string
      })
    )
    redirect_setting = list(
      object({
        name                        = string
        paths                       = list(string)
        backend_http_settings_name  = string
        backend_address_pool_name   = string
        redirect_configuration_name = string
      })
    )
    default_backend_address_pool_name   = string
    backend_settings_name               = string
    default_redirect_configuration_name = string
  }))
  description = "Maps directly to Application gateways's url_path_map."
  default     = []
}

variable "request_routing_rules" {
  type = list(object({
    name                        = string
    priority                    = number
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    url_path_map_name           = string
    rule_type                   = string
    redirect_configuration_name = string
  }))
}

variable "rewrite_rule_sets" {

  type = list(object({
    name = string
    rewrite_rules = list(object({
      name          = string
      rule_sequence = string
      conditions = list(object({
        variable    = string
        pattern     = string
        ignore_case = bool
        negate      = bool
      }))
      request_header_configurations = list(object({
        header_name  = string
        header_value = string
      }))
      response_header_configurations = list(object({
        header_name  = string
        header_value = string
      }))
      urls = list(object({
        path         = string
        query_string = string
        reroute      = bool
      }))
    }))
  }))
  default = []
}

#########################WAF Configuration#########################

variable "waf_enabled" {
  type        = bool
  description = "(Required) Is the Web Application Firewall be enabled? Allowed values: true or false."
}

variable "waf_mode" {
  type        = string
  description = "(Required) The WAF mode, Prevention of Detection for test purposes."
  default     = "Prevention"
}

variable "waf_rule_version" {
  type        = string
  description = " (Optional) Required if waf_enabled is true. The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, 3.1 and 3.2"
  default     = "3.2"
}

variable "waf_file_upload_limit_mb" {
  type        = string
  default     = "100"
  description = "(Optional) Required if waf_enabled is true. The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB."
}
variable "waf_max_request_body_size_kb" {
  type        = string
  default     = "128"
  description = "(Optional) Required if waf_enabled is true. The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB."
}
variable "waf_disabled_rule_group" {
  type = list(
    object({
      rule_group_name = string
      rules           = list(string)
    })
  )
  description = "(Optional) List of rules that will be removed of the waf"
  default     = []
}


#########################SKU variables#########################

variable "sku_name" {
  type        = string
  description = "(Required) The Name of the SKU to use for this Application Gateway. Accepted values are Standard_v2 and WAF_v2. Please refrain from using the WAF_v2 mode (use only if necessary), instead use the Santander Imperva WAF."
  default     = "Standard_v2"
}

variable "sku_tier" {
  type        = string
  description = "(Required) The Tier of the SKU to use for this Application Gateway. Accepted values are Standard_v2 and WAF_v2. Please refrain from using the WAF_v2 mode (use only if necessary), instead use the Santander Imperva WAF."
  default     = "Standard_v2"
}

variable "capacity" {
  type        = object({ min = number, max = number })
  description = "(Required) The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = null
}


#########################WAF config#########################

variable "cipher_suites" {
  type        = list(any)
  description = "(Required) A List of accepted cipher suites.  Accepted values are: TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_GCM_SHA384, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
  default     = ["TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"]
}

#########################NIC Association#####################

variable "create_backend_nic" {
  type        = bool
  description = "(Optional) Enable creation of a Network Interface Card for the Backend Address Pool Association. Accepted values are true or false"
  default     = false
}
variable "network_interfaces" {
  type        = list(string)
  description = "(Optional) Required if there are backend_address_pools and create_backend_nic is set to true. A list of names of network Interfaces that should be created. IE: nic01, nic02, ... in a format of a list of strings. It Needs to be the same number of network_interfaces as the number of backend_address_pools there are configured for the app gateway, and the same number of IPs in the private_ip_address_nic_association"
  default     = []
}

variable "subnet_ids_nic_association" {
  type        = list(string)
  description = "(Optional) Required only if create_backend_nic is set to true. IDs of the subnets used for NIC association to the backend."
  default     = []

}

variable "private_ip_addresses_nic_association" {
  type        = list(string)
  description = "(Optional) Required if there are backend_address_pools and create_backend_nic is set to true. A list of static private IP addresses which should be used to associate NIC within the backend address pool. As many IP addresses as network_interfaces and backend_address_pools there are. IMPORTANT: the IP addresses needs to be located in the subnet_id, and needs to be different from the IPs configured within the app gateway (backend_address_pools)"
  default     = []
}



variable "redirect_configurations" {
  type = list(object({
    name                 = string
    redirect_type        = string
    target_url           = string
    include_path         = bool
    include_query_string = bool
  }))
  description = "(Required) A list of redirections."
  default     = []
}