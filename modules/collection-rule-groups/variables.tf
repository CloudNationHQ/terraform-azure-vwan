variable "groups" {
  description = "contains all firewall policy rule collection groups config"
  type        = any
}

variable "ip_groups" {
  description = "describes all ip groups"
  type        = map(any)
  default     = {}
}

variable "location" {
  description = "contains the region"
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "contains the resourcegroup name"
  type        = string
  default     = null
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = null
}
