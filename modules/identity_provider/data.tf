data "tls_certificate" "this" {
  count = var.type == "OpenID connect" ? 1 : 0

  url = "https://${var.openid_connect.provider}"
}
