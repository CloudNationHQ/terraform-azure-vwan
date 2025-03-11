module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.23"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    address_space  = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
        network_security_group = {}
        address_prefixes       = ["10.19.1.0/24"]
      }
    }
  }
}

module "rg_vwan" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  providers = {
    azurerm = azurerm.connectivity
  }


  groups = {
    vwan = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 4.0"

  providers = {
    azurerm = azurerm.connectivity
  }

  naming = local.naming

  vwan = {
    name                           = module.naming.virtual_wan.name
    resource_group                 = module.rg_vwan.groups.vwan.name
    location                       = module.rg_vwan.groups.vwan.location
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false


    vhubs = {
      weu = {
        location       = "westeurope"
        address_prefix = "10.0.0.0/23"
      }
    }
  }
}

module "vhub-connection" {
  source  = "cloudnationhq/vwan/azure//modules/vhub-connection"
  version = "~> 4.0"

  providers = {
    azurerm = azurerm.connectivity
  }

  virtual_hub = {
    resource_group = module.vwan.vwan.resource_group_name
    name           = module.vwan.vhubs.weu.name

    connections = {
      prod = {
        name                      = "vhcon-demo-prod-weu"
        remote_virtual_network_id = module.network.vnet.id
        internet_security_enabled = false
      }
    }
  }
  depends_on = [module.vwan]
}
