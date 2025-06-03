module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.23"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "vwan" {
  source  = "cloudnationhq/vwan/azure"
  version = "~> 4.0"

  naming = local.naming

  location       = module.rg.groups.demo.location
  resource_group = module.rg.groups.demo.name

  vwan = {
    name                           = module.naming.virtual_wan.name
    vhubs                          = local.vhubs
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
  }
}

module "firewall" {
  source  = "cloudnationhq/fw/azure"
  version = "~> 2.0"

  resource_group = module.rg.groups.demo.name
  for_each       = local.firewalls

  instance = each.value
}

module "vhub_route_tables" {
  source  = "cloudnationhq/vwan/azure//modules/vhub-route-table"
  version = "~> 4.0"

  naming = local.naming

  route_tables = local.route_tables
}
