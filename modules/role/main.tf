resource "aws_iam_role" "this" {
  name                 = var.name
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary = one(data.aws_iam_policy.permissions_boundary[*].arn)

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = data.aws_iam_policy.managed_policies

  role       = aws_iam_role.this.id
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy" "this" {
  for_each = data.aws_iam_policy_document.inline_policy

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value.json
}
