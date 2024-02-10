# ip groups
resource "azurerm_ip_group" "ipgroup" {
  for_each = try(var.ip_groups, {})

  name                = try(each.value.name, join("-", [var.naming.ip_group, each.key]))
  location            = var.location
  resource_group_name = var.resourcegroup

  lifecycle {
    ignore_changes = [cidrs]
  }
}

# ip group cidrs
resource "azurerm_ip_group_cidr" "ipcidr" {
  for_each = local.flattened_ip_groups

  ip_group_id = azurerm_ip_group.ipgroup[each.value.group].id
  cidr        = each.value.cidr
}
