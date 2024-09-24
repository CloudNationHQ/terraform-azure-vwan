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
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 2.0"

  vwan = {
    name                           = module.naming.virtual_wan.name
    resource_group                 = module.rg.groups.demo.name
    location                       = module.rg.groups.demo.location
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}
