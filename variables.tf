variable "vwan" {
  description = "describes virtual wan configuration"
  type        = any
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}
