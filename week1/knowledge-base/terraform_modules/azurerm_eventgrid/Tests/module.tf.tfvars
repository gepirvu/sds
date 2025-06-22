project_name        = "cloudinfra"
subscription        = "np"
environment         = "dv"
resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"


virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
pe_subnet_name                      = "pe"

eventgrid_domain_config = [
  {
    eventgrid_domain_purpose = "testdomain1"
    event_schema             = "CloudEventSchemaV1_0"
    system_assigned_identity = true
    topics = [
      {
        topic_name    = "testdomain1topic1"
        subscriptions = []
      }
    ]
  },
  {
    eventgrid_domain_purpose = "testdomain2"
    event_schema             = "CloudEventSchemaV1_0"
    system_assigned_identity = true
    topics = [
      {
        topic_name    = "testdomain2topic1"
        subscriptions = []
      }
    ]
  }
]
