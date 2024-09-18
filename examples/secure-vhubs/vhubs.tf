locals {
  vhubs = {
    weu = {
      location       = "westeurope"
      address_prefix = "10.0.0.0/23"
    }
    eus = {
      location       = "eastus"
      address_prefix = "10.1.0.0/23"
    }
  }
}
