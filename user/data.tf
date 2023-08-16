data "aws_iam_policy" "this" {
  count = var.permissions_boundary != null ? 1 : 0

  name = var.permissions_boundary
}
