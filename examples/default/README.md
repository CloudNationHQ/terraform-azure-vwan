This example illustrates the defaul tvirtual wan setup, in its simplest form.

## Usage

```hcl
module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 0.8"

  naming = local.naming

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  vwan = {
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}
```
