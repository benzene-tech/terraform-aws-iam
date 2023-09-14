resource "aws_iam_role" "this" {
  name                 = var.name
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns  = [for policy in data.aws_iam_policy.managed_policies : policy.arn]
  permissions_boundary = one(data.aws_iam_policy.permissions_boundary[*].arn)

  dynamic "inline_policy" {
    for_each = keys(local.inline_policies)

    content {
      name   = inline_policy.value
      policy = data.aws_iam_policy_document.inline_policy[inline_policy.value].json
    }
  }

  tags = var.tags
}
