module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 7.0"

  vwan = {
    name                           = module.naming.virtual_wan.name
    resource_group_name            = module.rg.groups.demo.name
    location                       = module.rg.groups.demo.location
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}
