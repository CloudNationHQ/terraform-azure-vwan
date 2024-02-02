# Collection Rule Groups

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.61 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy_rule_collection_group.group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_ip_group.ipgroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group) | resource |
| [azurerm_ip_group_cidr.ipcidr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group_cidr) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | contains all firewall policy rule collection groups config | `any` | n/a | yes |
| <a name="input_ip_groups"></a> [ip\_groups](#input\_ip\_groups) | n/a | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | contains the region | `string` | `null` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | contains naming convention | `map(string)` | `null` | no |
| <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup) | contains the resourcegroup name | `string` | `null` | no |
