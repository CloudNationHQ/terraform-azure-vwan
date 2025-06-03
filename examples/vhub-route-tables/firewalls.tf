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
    eus = {
      name     = "fw-demo-dev-eus"
      location = "eastus"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      virtual_hub = {
        virtual_hub_id = module.vwan.vhubs.eus.id
      }
    }
  }
}
