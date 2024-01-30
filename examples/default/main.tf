module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "northeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 0.1"

  naming = local.naming

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  vwan = {
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}
