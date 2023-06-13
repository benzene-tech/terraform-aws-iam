variable "name" {
  description = "Name of the role"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,\\.@\\-_]+$", var.name))
    error_message = "Role's name can contain only alphanumeric and '+=,.@-_' characters"
  }
}

variable "path" {
  description = "Path in which to create the role. Must begin and end with /"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^(?:/[\u0021-\u007E]+)+/$", var.path)) || var.path == null
    error_message = "Role's path should start and end with '/' and contain non-whitespace characters"
  }
}

variable "assume_role_policy" {
  description = "Policy that grants an entity permission to assume the role"
  type        = string
  nullable    = false
}

variable "policies" {
  description = "Set of policies to be attached to the role"
  type        = set(string)
  default     = []
  nullable    = false
}

variable "inline_policies" {
  description = "Inline policies to be attached to the role"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "permissions_boundary" {
  description = "Policy name to be attached as permission boundary to the role"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be assigned to the role"
  type        = map(string)
  default     = null
}
