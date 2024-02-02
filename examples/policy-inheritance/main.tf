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

  naming        = local.naming
  location      = module.rg.groups.demo.location
  resourcegroup = module.rg.groups.demo.name

  vwan = {
    vhubs = {
      northeurope = {
        name           = module.naming.virtual_hub.name
        resourcegroup  = module.rg.groups.demo.name
        location       = "northeurope"
        address_prefix = "10.0.0.0/23"
        policy = {
          base_policy_id = module.fwp_inheritance.policy.base.id
        }
      }
    }
  }
}

module "collection_rule_groups" {
  source  = "cloudnationhq/vwan/azure//modules/collection-rule-groups"
  version = "~> 0.1"

  naming        = local.naming
  groups        = local.collection_rule_groups
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
}

module "fwp_inheritance" {
  source = "cloudnationhq/vwan/azure//modules/firewall-policy"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  policy = {
    base = {
      name = "fwp-demo-dev-base"
    }
  }
}
