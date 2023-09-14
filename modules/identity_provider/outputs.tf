output "name" {
  value = try(trimprefix(one(aws_iam_openid_connect_provider.this[*].url), "https://"), one(aws_iam_saml_provider.this[*].name))
}
