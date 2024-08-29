This example highlights the seamless integration of IP groups and collection rule groups using firewall policy inheritence.

## Usage

```hcl
module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 0.11"

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
```

```hcl
module "collection_rule_groups" {
  source  = "cloudnationhq/vwan/azure//modules/collection-rule-groups"
  version = "~> 0.1"

  naming = local.naming
  groups = local.collection_rule_groups

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  depends_on = [module.vwan, module.ip_groups]
}
```

```hcl
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
```

```hcl
module "ip_groups" {
  source  = "cloudnationhq/vwan/azure//modules/ip-groups"
  version = "~> 0.1"

  naming     = local.naming
  ip_groups  = local.ip_groups
  depends_on = [module.vwan]

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
}
```

The locals below are utilized to store config,

```hcl
locals {
  ip_groups = {
    internal-networks = {
      name = "ipg-internal-corporate-networks"
      cidr = [
        "10.1.0.0/16", "172.20.0.0/16", "192.168.1.0/24",
        "192.168.2.0/24", "192.168.5.0/24", "10.2.0.0/16",
        "10.3.0.0/16", "172.21.0.0/16", "172.22.0.0/16",
        "10.4.0.0/16"
      ]
    }
    remote-workers = {
      name = "ipg-remote-workers-vpn"
      cidr = [
        "10.200.0.0/16", "10.201.0.0/16", "10.202.0.0/16",
        "10.203.0.0/16", "10.204.0.0/16", "10.205.0.0/16",
        "10.206.0.0/16", "10.207.0.0/16", "10.208.0.0/16",
        "10.209.0.0/16"
      ]
    }
  }
}
```

```hcl
locals {
  collection_rule_groups = {
    default = {
      name               = "EnhancedSecurityRuleCollectionGroup"
      priority           = 200
      firewall_policy_id = module.fwpolicy.policy.parent.id
      network_rule_collections = {
        CorporateWebAccessRules = {
          priority = 100
          action   = "Allow"
          rules = {
            allowHttpHttps = {
              name                  = "AllowHTTPandHTTPS"
              protocols             = ["TCP"]
              destination_ports     = ["80", "443"]
              source_ip_groups      = [module.ip_groups.groups.internal-networks.id]
              destination_addresses = ["*"]
            }
            allowVpnAccess = {
              name                  = "AllowVPNAccess"
              protocols             = ["UDP"]
              destination_ports     = ["1194", "500", "4500"]
              source_ip_groups      = [module.ip_groups.groups.remote-workers.id]
              destination_addresses = ["*"]
            }
          }
        }
      }
    }
  }
}
```
