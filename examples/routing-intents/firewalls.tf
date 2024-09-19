locals {
  firewalls = {
    weu = {
      name     = "fw-demo-dev-weu"
      location = "westeurope"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      virtual_hub = {
        virtual_hub_id = module.vwan.vhubs.weu.id
      }
    }
    sea = {
      name     = "fw-demo-dev-sea"
      location = "southeastasia"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      virtual_hub = {
        virtual_hub_id = module.vwan.vhubs.sea.id
      }
    }
  }
}
