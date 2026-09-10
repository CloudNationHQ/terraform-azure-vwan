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
    vhubs                          = local.vhubs
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}

module "routing_intents" {
  source  = "cloudnationhq/vwan/azure//modules/routing-intent"
  version = "~> 7.0"

  configs = {
    weu = {
      virtual_hub_id = module.vwan.vhubs.weu.id
      routing_policies = {
        internet_policy = {
          destinations = ["Internet"]
          next_hop     = module.firewall.weu.firewall.id
        }
      }
    }
    sea = {
      virtual_hub_id = module.vwan.vhubs.sea.id
      routing_policies = {
        internet_policy = {
          destinations = ["Internet"]
          next_hop     = module.firewall.sea.firewall.id
        }
      }
    }
  }
}

module "firewall" {
  source  = "cloudnationhq/fw/azure"
  version = "~> 4.0"

  resource_group_name = module.rg.groups.demo.name
  for_each            = local.firewalls

  firewall = each.value
}
