This example demonstrates managing collection groups using IP groups within secure virtual hubs.

## Usage

```hcl
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
      }
    }
  }
}
```

```hcl
module "collection_rule_groups" {
  source = "cloudnationhq/vwan/azure//modules/collection-rule-groups"
  version = "~> 0.1"

  naming    = local.naming
  groups    = local.collection_rule_groups
  ip_groups = local.ip_groups

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
}
```

```hcl
locals {
  collection_rule_groups = {
    default = {
      priority           = 50000
      firewall_policy_id = module.vwan.firewall_policy.northeurope.id
      network_rule_collections = [
        {
          key      = "netw_rules"
          priority = 60000
          action   = "Allow"
          rules = {
            rule1 = {
              protocols             = ["TCP"]
              destination_ports     = ["*"]
              destination_addresses = local.ip_groups.deny.cidr
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
      ]
      application_rule_collections = [
        {
          key      = "app_rules"
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
          key      = "nat_rules"
          priority = 20000
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
      ]
    }
  }
}
```

```hcl
locals {
  ip_groups = {
    allow = {
      cidr = ["192.168.1.0/24"]
    }
    deny = {
      cidr = ["10.2.0.0/24"]
    }
  }
}
```
