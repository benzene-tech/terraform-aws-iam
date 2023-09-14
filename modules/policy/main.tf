resource "aws_iam_policy" "this" {
  name   = var.name
  path   = var.path
  policy = data.aws_iam_policy_document.this.json

  tags = var.tags
}
