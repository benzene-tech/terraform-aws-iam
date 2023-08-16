output "name" {
  value = aws_iam_group.this.name

  depends_on = [aws_iam_group_membership.this]
}
