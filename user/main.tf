resource "aws_iam_user" "this" {
  name                 = var.name
  path                 = var.path
  permissions_boundary = one(data.aws_iam_policy.permissions_boundary[*].arn)

  tags = var.tags
}

resource "aws_iam_user_policy" "this" {
  for_each = data.aws_iam_policy_document.this

  name   = each.key
  user   = aws_iam_user.this.name
  policy = each.value.json
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = data.aws_iam_policy.managed_policies

  user       = aws_iam_user.this.name
  policy_arn = each.value.arn
}
