variable "name" {
  description = "Name of the user"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,\\.@\\-_]+$", var.name))
    error_message = "User's name can contain only alphanumeric and '+=,.@-_' characters"
  }
}

variable "path" {
  description = "Path in which to create the user. Must begin and end with /"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^(?:/[\u0021-\u007E]+)+/$", var.path)) || var.path == null
    error_message = "Role's path should start and end with '/' and contain non-whitespace characters"
  }
}

variable "permissions_boundary" {
  description = "Policy name to be attached as permission boundary to the user"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be assigned to the user"
  type        = map(string)
  default     = null
}
