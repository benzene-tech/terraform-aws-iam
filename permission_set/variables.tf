variable "name" {
  description = "Name of the permission set"
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 32
    error_message = "Permission set's name are limited to 32 characters or less"
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,\\.@\\-_]+$", var.name))
    error_message = "Permission set's name can contain only alphanumeric and '+=,.@-_' characters"
  }
}

variable "ssoadmin_instance" {
  description = "ARN of SSO admin instance"
  type        = string
  nullable    = false
}

variable "aws_managed_policies" {
  description = "List of AWS managed policies to be attached to the permission set"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "customer_managed_policies" {
  description = "Customer managed policies to be attached to the permission set"
  type        = map(string)
  default     = {}
  nullable    = false

  validation {
    condition     = alltrue([for name, path in var.customer_managed_policies : (can(regex("^(?:/[\u0021-\u007E]+)+/$", path)) || path == null)])
    error_message = "Police's path should start and end with '/' and contain non-whitespace characters"
  }
}

variable "inline_policy_document" {
  description = "JSON encoded inline policy document for permission set"
  type        = string
  default     = "null"
  nullable    = false
}

variable "tags" {
  description = "Tags to be assigned to the permission set"
  type        = map(string)
  default     = null
}
