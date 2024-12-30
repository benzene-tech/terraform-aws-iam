resource "aws_iam_group" "this" {
  name = var.name
  path = var.path
}

resource "aws_iam_group_membership" "this" {
  count = var.users != null ? 1 : 0

  name  = var.name
  users = var.users
  group = aws_iam_group.this.name
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = data.aws_iam_policy.this

  group      = aws_iam_group.this.name
  policy_arn = each.value.arn
}

resource "aws_iam_group_policy_attachments_exclusive" "this" {
  count = var.exclusive.role_policy_attachment ? 1 : 0

  group_name  = aws_iam_group.this.name
  policy_arns = [for _, policy in try(aws_iam_group_policy_attachment.this, {}) : policy.policy_arn]
}

resource "aws_iam_group_policy" "this" {
  for_each = data.aws_iam_policy_document.this

  name   = each.key
  group  = aws_iam_group.this.name
  policy = each.value.json
}

resource "aws_iam_group_policies_exclusive" "this" {
  count = var.exclusive.role_policy ? 1 : 0

  group_name   = aws_iam_group.this.name
  policy_names = [for _, policy in try(aws_iam_group_policy.this, {}) : policy.name]
}
