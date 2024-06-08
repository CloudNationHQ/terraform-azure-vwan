This example illustrates configuring multiple secure virtual hubs with their associated policy.

## Usage

```hcl
module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 0.9"

  naming        = local.naming
  location      = module.rg.groups.demo.location
  resourcegroup = module.rg.groups.demo.name

  vwan = {
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false

    vhubs = local.vhubs
  }
}
```

The local below is utilized to store config,

```hcl
locals {
  vhubs = {
    northeurope = {
      resourcegroup  = module.rg.groups.demo.name
      location       = "northeurope"
      address_prefix = "10.0.0.0/23"
      firewall_tier  = "Premium"
      policy = {
        location = "northeurope"
        dns = {
          proxy_enabled = true
          servers       = ["7.7.7.7", "8.8.8.8"]
        }
      }
    }
    southcentralus = {
      resourcegroup  = module.rg.groups.demo.name
      location       = "southcentralus"
      address_prefix = "11.0.0.0/23"
      firewall_tier  = "Premium"
      policy = {
        location = "northeurope"
      }
    }
  }
}
```
