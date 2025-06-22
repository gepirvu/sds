location           = "West Europe"
environment        = "dev"
project_name       = "ssp"
subscription       = "np"
service_plan_usage = "workflow"
#service_plan_os_type       = "WorkflowStandard"
service_plan_os_type           = "Windows"
service_plan_sku_name          = "WS1"
user_assigned_identity_name    = "axso-np-appl-ssp-test-umid"
resource_group_name            = "axso-np-appl-ssp-test-rg"
vint_subnet_name               = "app-workflow-subnet"
logic_app_storage_account_name = "axso4p4ssp4np4testsa"
pe_subnet_name                 = "app-workflow-pe-subnet"

logic_app = [
  {
    logic_app_description = "chache-refresh"
    requires_identity     = false

  },
  {
    logic_app_description = "cache-clean"
    requires_identity     = true

  }
]
