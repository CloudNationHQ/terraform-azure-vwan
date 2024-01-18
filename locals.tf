locals {
  ip_groups = {
    group1 = ["192.168.1.0/24"]
    group2 = ["10.1.0.0"]
  }
}

locals {
  firewall_rule_collection_groups_list = {
    test = {
      priority = 50000
      network_rule_collections = [
        {
          key      = "network_rule_collections_test_2"
          priority = 60000
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
            rule3 = {
              protocols             = ["TCP"]
              destination_ports     = ["*"]
              destination_addresses = local.ip_groups.group2
              source_addresses      = ["10.0.0.0/8"]
            }
          }
        }
      ]
      application_rule_collections = [
        {
          key      = "app_rule_collection_1"
          priority = 10000
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
        },
      ]
      nat_rule_collections = [
        {
          key      = "nat_rule_collection_1"
          priority = 20000
          action   = "Dnat"
          rules = {
            rule1 = {
              source_addresses    = ["145.23.23.23", "10.0.0.0/8"]
              destination_ports   = ["4430"]
              destination_address = "20.23.230.20" # public ip firewall
              translated_port     = "443"
              translated_address  = "10.0.0.10"
              protocols           = ["TCP"]
            }
          }
        }
      ]
    }
  }
}
