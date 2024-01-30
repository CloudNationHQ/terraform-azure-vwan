locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["virtual_wan", "firewall", "firewall_policy", "virtual_hub"]
}

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
