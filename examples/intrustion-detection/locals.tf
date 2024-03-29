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
        sku      = "Premium"
        intrusion_detection = {
          mode = "Alert"
          traffic_bypass = {
            bypass1 = {
              protocol              = "TCP"
              description           = "bypass1"
              source_addresses      = ["10.0.1.0"]
              destination_addresses = ["10.1.0.0"]
              destination_ports     = ["*"]
            }
            bypass2 = {
              protocol              = "TCP"
              description           = "bypass2"
              source_addresses      = ["10.0.2.0"]
              destination_addresses = ["10.2.0.0"]
              destination_ports     = ["*"]
            }
          }
          signature_overrides = {
            or1 = {
              id    = "948321945312"
              state = "Alert"
            }
          }
        }
      }
    }
  }
}
