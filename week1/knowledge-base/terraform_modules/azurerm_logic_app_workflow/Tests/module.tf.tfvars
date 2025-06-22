location                    = "West Europe"
environment                 = "dev"
project_name                = "ssp"
subscription                = "np"
user_assigned_identity_name = "axso-np-appl-ssp-test-umid"
resource_group_name         = "axso-np-appl-ssp-test-rg"

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
