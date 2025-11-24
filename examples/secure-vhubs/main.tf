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
  version = "~> 6.0"

  naming              = local.naming
  location            = module.rg.groups.demo.location
  resource_group_name = module.rg.groups.demo.name

  vwan = {
    name                           = module.naming.virtual_wan.name
    vhubs                          = local.vhubs
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}

module "firewall" {
  source  = "cloudnationhq/fw/azure"
  version = "~> 3.0"

  resource_group_name = module.rg.groups.demo.name
  for_each            = local.firewalls

  instance = each.value
}

module "fw_policy" {
  source  = "cloudnationhq/fwp/azure"
  version = "~> 4.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  config = {
    name                     = module.naming.firewall_policy.name
    threat_intelligence_mode = "Alert"
  }
}

module "collection_rule_groups" {
  source  = "cloudnationhq/fwp/azure//modules/collection-rule-groups"
  version = "~> 4.0"

  groups = local.collection_rule_groups
}

locals {
  collection_rule_groups = {
    default = {
      priority           = 1000
      firewall_policy_id = module.fw_policy.config.id
      network_rule_collections = {
        allow_internal = {
          name     = "allow-internal-traffic"
          priority = 1000
          action   = "Allow"
          rules = {
            allow_vnet_to_vnet = {
              protocols             = ["TCP", "UDP"]
              destination_ports     = ["*"]
              destination_addresses = ["10.0.0.0/8"]
              source_addresses      = ["10.0.0.0/8"]
            }
          }
        }
      }
      application_rule_collections = {
        allow_microsoft = {
          name     = "allow-microsoft-services"
          priority = 2000
          action   = "Allow"
          rules = {
            allow_microsoft_com = {
              source_addresses  = ["10.0.0.0/8"]
              destination_fqdns = ["*.microsoft.com", "*.azure.com"]
              protocols = [
                {
                  type = "Https"
                  port = 443
                }
              ]
            }
          }
        }
      }
    }
  }
}
