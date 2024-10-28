locals {
  vhubs = {
    weu = {
      location       = "westeurope"
      address_prefix = "10.0.0.0/23"
      site_to_site_vpn = {
        name = "weu-s2s-gateway"
        nat_rules = {
          rule1 = {
            external_mappings = {
              mapping1 = {
                address_space = "192.168.21.0/26"
              }
            }
            internal_mappings = {
              mapping1 = {
                address_space = "10.4.0.0/26"
              }
            }
          }
          rule2 = {
            external_mappings = {
              mapping1 = {
                address_space = "192.168.22.0/26"
                port_range    = "10000-20000"
              }
            }
            internal_mappings = {
              mapping1 = {
                address_space = "10.5.0.0/26"
                port_range    = "10000-20000"
              }
            }
          }
        }
        vpn_sites = {
          site1 = {
            address_prefix = "192.168.1.0/24"
            gateway_ip     = "192.168.1.1"
            vpn_links = {
              link1 = {
                ip_address    = "203.0.113.1"
                provider_name = "ISP1"
                speed_in_mbps = 100
              }
            }
            connections = {
              connection1 = {
                shared_key            = "YourSharedKey1"
                connection_type       = "IPsec"
                routing_weight        = 10
                local_address_ranges  = ["10.0.0.0/16"]
                remote_address_ranges = ["192.168.1.0/24"]
                vpn_links = {
                  link1 = {
                    shared_key  = "YourLinkSharedKey1"
                    bgp_enabled = false
                    protocol    = "IKEv2"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
