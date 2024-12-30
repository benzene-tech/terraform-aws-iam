variable "name" {
  description = "Name of the group"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,\\.@\\-_]+$", var.name))
    error_message = "Group's name can contain only alphanumeric and '+=,.@-_' characters"
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

variable "users" {
  description = "Users to be assigned to the group"
  type        = set(string)
  default     = null
}

variable "policies" {
  description = "Set of policies to be attached to the group"
  type        = set(string)
  default     = []
  nullable    = false
}

variable "policy_documents" {
  description = "Policy documents to be attached to the group"
  type        = map(any)
  default     = {}
  nullable    = false
}

variable "tags" {
  description = "Tags to be assigned to the group"
  type        = map(string)
  default     = null
}
