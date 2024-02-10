output "groups" {
  description = "contains all ip groups configuration"
  value = {
    for k, ipgroup in azurerm_ip_group.ipgroup : k => ipgroup
  }
}
