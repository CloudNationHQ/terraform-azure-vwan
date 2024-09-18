# virtual wan
resource "azurerm_virtual_wan" "vwan" {
  name                              = var.vwan.name
  resource_group_name               = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                          = coalesce(lookup(var.vwan, "location", null), var.location)
  allow_branch_to_branch_traffic    = try(var.vwan.allow_branch_to_branch_traffic, true)
  disable_vpn_encryption            = try(var.vwan.disable_vpn_encryption, false)
  type                              = try(var.vwan.type, "Standard")
  office365_local_breakout_category = try(var.vwan.office365_local_breakout_category, "None")
  tags                              = try(var.vwan.tags, {})
}

# vhubs
resource "azurerm_virtual_hub" "vhub" {
  for_each = lookup(
    var.vwan, "vhubs", {}
  )

  name                   = try(each.value.name, join("-", [var.naming.virtual_hub, each.key]))
  resource_group_name    = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location               = coalesce(lookup(var.vwan, "location", null), var.location)
  address_prefix         = each.value.address_prefix
  virtual_wan_id         = azurerm_virtual_wan.vwan.id
  sku                    = try(each.value.sku, "Standard")
  hub_routing_preference = try(each.value.hub_routing_preference, "ExpressRoute")
  tags                   = try(each.value.tags, {})
}
