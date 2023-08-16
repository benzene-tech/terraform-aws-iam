resource "aws_iam_user" "this" {
  name                 = var.name
  path                 = var.path
  permissions_boundary = one(data.aws_iam_policy.this[*].arn)

  tags = var.tags
}
