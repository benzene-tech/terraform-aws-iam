variable "type" {
  description = "Provider type"
  type        = string
  nullable    = false

  validation {
    condition     = contains(["OpenID connect", "SAML"], var.type)
    error_message = "Provider type supported are either 'OpenID connect' or 'SAML'"
  }
}

variable "openid_connect" {
  description = "OpenID Connect provider config"
  type = object({
    provider = string
    audience = set(string)
  })
  default = null
}

variable "saml" {
  description = "SAML provider config"
  type = object({
    name              = string
    metadata_document = string
  })
  default = null

  validation {
    condition     = can(regex("^[A-Za-z0-9\\.\\-_]+$", var.saml.name)) || var.saml == null
    error_message = "Role's name can contain only alphanumeric and '+=,.@-_' characters"
  }
}

variable "tags" {
  description = "Tags to be assigned to the provider"
  type        = map(string)
  default     = null
}
