module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

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

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 3.0"

  naming         = local.naming
  location       = module.rg.groups.demo.location
  resource_group = module.rg.groups.demo.name

  vwan = {
    name                           = module.naming.virtual_wan.name
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
    vhubs = {
      weu = {
        location       = "westeurope"
        address_prefix = "10.0.0.0/23"
        express_route_gateway = {
          scale_units = 1
        }
      }
    }
  }
}

module "firewall" {
  source  = "cloudnationhq/fw/azure"
  version = "~> 2.0"

  resource_group = module.rg.groups.demo.name

  instance = {
    name     = module.naming.firewall.name
    location = module.rg.groups.demo.location

    sku_name = "AZFW_Hub"
    sku_tier = "Standard"
    virtual_hub = {
      virtual_hub_id = module.vwan.vhubs.weu.id
    }
  }
}
