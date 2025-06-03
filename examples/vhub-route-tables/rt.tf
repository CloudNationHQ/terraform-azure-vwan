locals {
  route_tables = {
    weu = {
      labels         = ["firewall", "security"]
      virtual_hub_id = module.vwan.vhubs.weu.id

      routes = {
        default = {
          destinations_type = "CIDR"
          destinations      = ["0.0.0.0/0"]
          next_hop_type     = "ResourceId"
          next_hop          = module.firewall["weu"].instance.id
        }
      }
    }

    eus = {
      labels         = ["firewall"]
      virtual_hub_id = module.vwan.vhubs.eus.id

      routes = {
        default = {
          destinations_type = "CIDR"
          destinations      = ["0.0.0.0/0"]
          next_hop_type     = "ResourceId"
          next_hop          = module.firewall["eus"].instance.id
        }
      }
    }
  }
}
