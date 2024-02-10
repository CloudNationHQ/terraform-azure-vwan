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
          base_policy_id = module.fwpolicy.policy.parent.id
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

  depends_on = [module.vwan, module.ip_groups]
}

module "fwpolicy" {
  source  = "cloudnationhq/vwan/azure//modules/firewall-policy"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  policy = {
    parent = {
      name = "fwp-demo-dev-parent"
    }
  }
}

module "ip_groups" {
  source  = "cloudnationhq/vwan/azure//modules/ip-groups"
  version = "~> 0.1"

  naming     = local.naming
  ip_groups  = local.ip_groups
  depends_on = [module.vwan]

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
}
