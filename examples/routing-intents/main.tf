module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

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
  version = "~> 5.0"

  naming = local.naming

  vwan = {
    name                           = module.naming.virtual_wan.name
    resource_group_name            = module.rg.groups.demo.name
    location                       = module.rg.groups.demo.location
    vhubs                          = local.vhubs
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}

module "routing_intents" {
  source  = "cloudnationhq/vwan/azure//modules/routing-intent"
  version = "~> 5.0"

  configs = {
    weu = {
      virtual_hub_id = module.vwan.vhubs.weu.id
      routing_policies = {
        internet_policy = {
          destinations = ["Internet"]
          next_hop     = module.firewall.weu.instance.id
        }
      }
    }
    sea = {
      virtual_hub_id = module.vwan.vhubs.sea.id
      routing_policies = {
        internet_policy = {
          destinations = ["Internet"]
          next_hop     = module.firewall.sea.instance.id
        }
      }
    }
  }
}

module "firewall" {
  source  = "cloudnationhq/fw/azure"
  version = "~> 3.0"

  resource_group_name = module.rg.groups.demo.name
  for_each            = local.firewalls

  instance = each.value
}
