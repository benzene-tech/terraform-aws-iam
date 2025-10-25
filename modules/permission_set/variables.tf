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
  description = "AWS managed policies to be attached to the permission set"
  type        = set(string)
  default     = []
  nullable    = false
}

variable "customer_managed_policies" {
  description = "Customer managed policies to be attached to the permission set"
  type        = set(string)
  default     = []
  nullable    = false
}

variable "inline_policy" {
  description = "Inline policy for permission set"
  type        = string
  default     = "null"
  nullable    = false
}

variable "permissions_boundary" {
  description = "Policy name to be attached as permission boundary to the role"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be assigned to the permission set"
  type        = map(string)
  default     = null
}
