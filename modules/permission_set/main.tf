resource "aws_ssoadmin_permission_set" "this" {
  name         = var.name
  instance_arn = var.ssoadmin_instance

  tags = var.tags
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = var.aws_managed_policies

  instance_arn       = var.ssoadmin_instance
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  managed_policy_arn = data.aws_iam_policy.this[each.value].arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = var.customer_managed_policies

  instance_arn       = aws_ssoadmin_permission_set.this.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  customer_managed_policy_reference {
    name = each.value
    path = data.aws_iam_policy.this[each.value].path
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  count = local.inline_policy != null ? 1 : 0

  inline_policy      = one(data.aws_iam_policy_document.this[*].json)
  instance_arn       = var.ssoadmin_instance
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}

resource "aws_ssoadmin_permissions_boundary_attachment" "this" {
  count = var.permissions_boundary != null ? 1 : 0

  instance_arn       = aws_ssoadmin_permission_set.this.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  permissions_boundary {
    managed_policy_arn = local.permissions_boundary_managed_by == "AWS" ? data.aws_iam_policy.this[var.permissions_boundary].arn : null

    dynamic "customer_managed_policy_reference" {
      for_each = local.permissions_boundary_managed_by == "Customer" ? [var.permissions_boundary] : []

      content {
        name = customer_managed_policy_reference.value
        path = data.aws_iam_policy.this[customer_managed_policy_reference.value].path
      }
    }
  }
}
