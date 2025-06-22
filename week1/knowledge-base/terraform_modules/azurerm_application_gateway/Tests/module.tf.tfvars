subscription                        = "np"
project_name                        = "prj"
environment                         = "dev"
location                            = "westeurope"
name                                = "test"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_name                = "vnet-ssp-nonprod-axso-vnet"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
virtual_network_resource_group_name = "axso-np-appl-ssp-test-rg"
vint_subnet_name                    = "appgw-subnet"


frontend_ip_private = "10.0.3.10"
frontend_port       = ["443"]

key_vault_rbac = true
appgw_public   = true

backend_address_pools = [
  {
    name  = "test-beap"
    ip    = ["10.0.4.4"]
    fqdns = []
  }
]
backend_http_settings = [
  {
    cookie_based_affinity           = "Disabled"
    name                            = "test-be-htst"
    path                            = ""
    port                            = "80"
    protocol                        = "Http"
    request_timeout                 = "20"
    host_name                       = "test.corp"
    probe_name                      = "test-probe"
    connection_draining_enabled     = false
    connection_draining_timeout_sec = "30"
    pick_hostname                   = false
  }
]


http_listeners = [
  {
    name                 = "test-httplstn"
    frontend_port_number = "443"
    protocol             = "Https"
    ssl_certificate_name = "test"
    host_name            = "test.com"
    require_sni          = false
  }
]

probes = [
  {
    name                  = "test-probe"
    interval              = "2"
    timeout               = "5"
    protocol              = "Http"
    path                  = "/"
    unhealthy_threshold   = "2"
    match_status_code     = ["200"]
    pick_hostname_backend = false
    host                  = "test.corp"
  }
]

request_routing_rules = [
  {
    name                        = "test-rqrt"
    priority                    = 1
    http_listener_name          = "test-httplstn"
    backend_address_pool_name   = "test-beap"
    backend_http_settings_name  = "test-be-htst"
    rule_type                   = "Basic"
    url_path_map_name           = ""
    redirect_configuration_name = ""
  }
]

waf_enabled  = true
waf_mode     = "Prevention"
sku_name     = "WAF_v2"
sku_tier     = "WAF_v2"
capacity_min = 1
capacity_max = 2

