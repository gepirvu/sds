resource_group_name                 = "rg-cloudinfra-nonprod-axso-ymiw" # Name of the network resource group
location                            = "westeurope"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"

nsgs = [
  {
    subnet_name         = "pe"
    associate_to_subnet = false
    nsg_rules = [
      {
        nsg_rule_name              = "DummyRule-Deny-Access-from"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "192.168.10.0/24"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        nsg_rule_name              = "DummyRule-Deny-Access-to"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "192.168.10.0/24"
      }
    ]
  },
  {
    subnet_name         = "aks"
    associate_to_subnet = true
    nsg_rules = [
      {
        nsg_rule_name              = "DummyRule-Deny-Access-from"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "192.168.10.0/24"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        nsg_rule_name              = "DummyRule-Deny-Access-to"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "192.168.10.0/24"
      }
    ]
  }
]