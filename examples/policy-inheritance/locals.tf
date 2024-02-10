locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["virtual_wan", "firewall", "firewall_policy"]
}

locals {
  collection_rule_groups = {
    default = {
      priority           = 1000
      firewall_policy_id = module.fwpolicy.policy.parent.id
      network_rule_collections = {
        netw_rules = {
          name     = "netwrules"
          priority = 7000
          action   = "Allow"
          rules = {
            rule1 = {
              protocols             = ["TCP"]
              destination_ports     = ["*"]
              destination_addresses = ["10.0.1.0/8"]
              source_addresses      = ["10.0.0.0/8"]
            }
          }
        }
      }
    }
  }
}
