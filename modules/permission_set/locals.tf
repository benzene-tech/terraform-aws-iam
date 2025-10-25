locals {
  permissions_boundary_managed_by = var.permissions_boundary != null ? (can(regex("^arn:aws:iam::aws:policy/", data.aws_iam_policy.this[var.permissions_boundary].arn)) ? "AWS" : "Customer") : null
}
