subscription = "np"
project_name = "prj"
environment  = "dev"
location     = "westeurope"
vm_image = {
  publisher = "Debian"
  offer     = "debian-10"
  sku       = "10"
  version   = "latest"
}

vm_config = [
  {
    vm_size        = "Standard_B2s_v2"
    admin_username = "tester"
    vm_number      = "001"
    zone_id        = 1
    storage_data_disk_config = {
      disk1 = {
        disk_size_gb = 64
      },
      disk2 = {
        disk_size_gb = 128
      }
      # Add more disks as needed
    }
  }
]


network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
resource_group_name         = "axso-np-appl-ssp-test-rg"
virtual_network_name        = "vnet-cloudinfra-nonprod-axso-e3og"
subnet_name                 = "compute"
key_vault_name              = "kv-ssp-0-nonprod-axso"
