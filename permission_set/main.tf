resource "aws_ssoadmin_permission_set" "this" {
  name         = var.name
  instance_arn = var.ssoadmin_instance
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = var.aws_managed_policies

  instance_arn       = var.ssoadmin_instance
  managed_policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  count = length(var.customer_managed_policies) > 0 ? 1 : 0

  instance_arn       = aws_ssoadmin_permission_set.this.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  dynamic "customer_managed_policy_reference" {
    for_each = var.customer_managed_policies

    content {
      name = customer_managed_policy_reference.key
      path = customer_managed_policy_reference.value
    }
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
    managed_policy_arn = var.permissions_boundary.managed_by == "AWS" ? "arn:aws:iam::aws:policy/${var.permissions_boundary.policy_name}" : null
    dynamic "customer_managed_policy_reference" {
      for_each = var.permissions_boundary.managed_by == "Customer" ? { var.permissions_boundary.name : var.permissions_boundary.path } : {}

      content {
        name = customer_managed_policy_reference.key
        path = customer_managed_policy_reference.value
      }
    }
  }
}
