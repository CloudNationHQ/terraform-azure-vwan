locals {
  vhubs = {
    weu = {
      location       = "westeurope"
      address_prefix = "10.0.0.0/23"
    }
    sea = {
      location       = "southeastasia"
      address_prefix = "10.1.0.0/23"
    }
  }
}
