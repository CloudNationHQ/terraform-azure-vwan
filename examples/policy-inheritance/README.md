This example illustrates firewall policy inheritance using multiple secure vhubs in different regions.

## Usage

```hcl
module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 0.5"

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
```

```hcl
module "collection_rule_groups" {
  source = "cloudnationhq/vwan/azure//modules/collection-rule-groups"
  version = "~> 0.1"

  naming        = local.naming
  groups        = local.collection_rule_groups
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
}
```

```hcl
module "fwp_inheritance" {
  source = "cloudnationhq/vwan/azure//modules/firewall-policy"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  policy = {
    base = {
      name = "fwp-demo-dev-base"
    }
  }
}
```

The local below is utilized to store config,

```hcl
locals {
  collection_rule_groups = {
    default = {
      priority           = 50000
      firewall_policy_id = module.fwp_inheritance.policy.base.id
      network_rule_collections = [
        {
          key      = "netw_rules"
          priority = 60000
          action   = "Allow"
          rules = {
            rule1 = {
              protocols             = ["TCP"]
              destination_ports     = ["*"]
              destination_addresses = ["10.1.0.0/16"]
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
    }
  }
}
```
