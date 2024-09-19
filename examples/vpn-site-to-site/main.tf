module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 1.0"

  naming         = local.naming
  location       = module.rg.groups.demo.location
  resource_group = module.rg.groups.demo.name

  vwan = {
    name                           = module.naming.virtual_wan.name
    vhubs                          = local.vhubs
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}

module "firewall" {
  source  = "cloudnationhq/fw/azure"
  version = "~> 1.0"

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
