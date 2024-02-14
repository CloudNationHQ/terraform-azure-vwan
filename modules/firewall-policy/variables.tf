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

variable "policy" {
  description = "contains firewall policy configuration"
  type        = any
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = null
}
