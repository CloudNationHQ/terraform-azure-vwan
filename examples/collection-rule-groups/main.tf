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
      region = "westeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 0.1"

  naming        = local.naming
  location      = module.rg.groups.demo.location
  resourcegroup = module.rg.groups.demo.name

  vwan = {
    vhubs = {
      westeurope = {
        name           = module.naming.virtual_hub.name
        resourcegroup  = module.rg.groups.demo.name
        location       = "westeurope"
        address_prefix = "10.0.0.0/23"
        policy = {
          name     = module.naming.firewall_policy.name
          location = "westeurope"
        }
      }
    }
  }
}

module "collection_rule_groups" {
  source  = "cloudnationhq/vwan/azure//modules/collection-rule-groups"
  version = "~> 0.1"

  naming = local.naming
  groups = local.collection_rule_groups

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
}
