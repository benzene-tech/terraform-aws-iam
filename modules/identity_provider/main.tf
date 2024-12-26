resource "aws_iam_openid_connect_provider" "this" {
  count = var.type == "OpenID connect" ? 1 : 0

  url            = "https://${var.openid_connect.provider}"
  client_id_list = var.openid_connect.audience

  tags = var.tags
}

resource "aws_iam_saml_provider" "this" {
  count = var.type == "SAML" ? 1 : 0

  name                   = var.saml.name
  saml_metadata_document = file(var.saml.metadata_document)

  tags = var.tags
}
