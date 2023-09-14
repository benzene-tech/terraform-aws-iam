resource "aws_iam_openid_connect_provider" "this" {
  count = var.type == "OpenID connect" ? 1 : 0

  url             = one(data.tls_certificate.this[*].url)
  client_id_list  = var.openid_connect.audience
  thumbprint_list = one(data.tls_certificate.this[*].certificates[*].sha1_fingerprint)

  tags = var.tags
}

resource "aws_iam_saml_provider" "this" {
  count = var.type == "SAML" ? 1 : 0

  name                   = var.saml.name
  saml_metadata_document = file(var.saml.metadata_document)

  tags = var.tags
}
