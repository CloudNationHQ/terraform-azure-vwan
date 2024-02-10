locals {
  flattened_ip_groups = merge([
    for group_name, group_values in try(var.ip_groups, {}) : {
      for cidr in group_values.cidr : "${group_name}-${cidr}" => {
        group = group_name
        cidr  = cidr
      }
    }
  ]...)
}
