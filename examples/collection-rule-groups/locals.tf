locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["virtual_wan", "firewall", "firewall_policy", "ip_group"]
}

locals {
  collection_rule_groups = {
    default = {
      priority           = 1000
      firewall_policy_id = module.vwan.policy.westeurope.id
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
            rule2 = {
              protocols             = ["TCP"]
              destination_ports     = ["*"]
              destination_addresses = ["12.0.1.0/8"]
              source_addresses      = ["12.0.0.0/8"]
            }
          }
        }
      }
      application_rule_collections = {
        app_rules = {
          name     = "apprules"
          priority = 6000
          action   = "Deny"
          rules = {
            rule1 = {
              source_addresses  = ["10.0.0.1"]
              destination_fqdns = ["*.microsoft.com"]
              protocols = [
                {
                  type = "Https"
                  port = 443
                }
              ]
            }
            rule2 = {
              source_addresses  = ["10.0.0.1"]
              destination_fqdns = ["*.bing.com"]
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
      nat_rule_collections = {
        nat_rules = {
          name     = "natrules"
          priority = 8000
          action   = "Dnat"
          rules = {
            rule1 = {
              source_addresses    = ["145.23.23.23", "10.0.0.0/8"]
              destination_ports   = ["4430"]
              destination_address = module.vwan.firewall_public_ip_addresses.public_ip_addresses[0]
              translated_port     = "443"
              translated_address  = "10.0.0.10"
              protocols           = ["TCP"]
            }
          }
        }
      }
    }
  }
}
