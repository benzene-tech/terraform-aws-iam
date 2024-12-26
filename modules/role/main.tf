resource "aws_iam_role" "this" {
  name                 = var.name
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns  = [for policy in data.aws_iam_policy.managed_policies : policy.arn]
  permissions_boundary = one(data.aws_iam_policy.permissions_boundary[*].arn)

  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  for_each = keys(local.inline_policies)

  name = each.value
  role = aws_iam_role.this.id

  policy = data.aws_iam_policy_document.inline_policy[each.value].json
}
