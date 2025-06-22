location            = "West Europe"
subscription        = "np"
environment         = "dev"
project_name        = "mds"
resource_group_name = "axso-np-appl-ssp-test-rg"
key_vault_name      = "kv-ssp-0-nonprod-axso"

storage_accounts = [
  {
    #Datalake storage with storage containers
    storage_account_index            = "1"
    account_tier_storage             = "Standard"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "StorageV2"
    public_network_access_enabled    = false #Only for testing - allows external test agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = false
    is_hns_enabled                   = true #Enable datalake
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = [] #optional
    # Specify Network ACLs
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"]
  },
  {
    #Blob storage with storage containers
    storage_account_index            = "2"
    account_tier_storage             = "Standard"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "StorageV2"
    is_hns_enabled                   = false
    public_network_access_enabled    = false #Only for testing - allows external tst agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = false
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = ["test1", "test2"] #optional - no containers
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"] #Mandatory for encryption  
  },
  {
    #Blob storage with nfsv3 enabled
    storage_account_index            = "3"
    account_tier_storage             = "Standard"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "StorageV2"
    is_hns_enabled                   = true
    public_network_access_enabled    = true #Only for testing - allows external tst agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = true
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = ["test1"] #optional - no containers
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"] #Mandatory for encryption      
  },
  {
    #Premium Files storage   enabled
    storage_account_index            = "4"
    account_tier_storage             = "Premium"
    access_tier_storage              = "Hot"
    account_replication_type_storage = "LRS"
    account_kind_storage             = "FileStorage"
    is_hns_enabled                   = false
    public_network_access_enabled    = false #Only for testing - allows external tst agent to create containers (if false only internal agents can create containers via private endpoint)
    nfsv3_enabled                    = false
    network_name                     = "vnet-cloudinfra-nonprod-axso-e3og"
    sa_subnet_name                   = "pe-2"
    network_resource_group_name      = "rg-cloudinfra-nonprod-axso-ymiw"
    delete_retention_policy_days     = 0
    container_names                  = [] #optional - no containers  
    network_acl = {
      bypass         = ["AzureServices"]
      default_action = "Deny"
    }
    identity_type = "UserAssigned"
    umids_names   = ["axso-np-appl-ssp-test-umid"] #Mandatory for encryption  
  }
]
