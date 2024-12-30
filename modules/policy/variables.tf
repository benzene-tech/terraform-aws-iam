variable "name" {
  description = "Name of the policy"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,\\.@\\-_]+$", var.name))
    error_message = "Policy's name can contain only alphanumeric and '+=,.@-_' characters"
  }
}

variable "path" {
  description = "Path in which to create the policy. Must begin and end with /"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^(?:/[\u0021-\u007E]+)+/$", var.path)) || var.path == null
    error_message = "Policy's path should start and end with '/' and contain non-whitespace characters"
  }
}

variable "policy_document" {
  description = "Policy document"
  type        = map(any)
  nullable    = false
}

variable "tags" {
  description = "Tags to be assigned to the policy"
  type        = map(string)
  default     = null
}
