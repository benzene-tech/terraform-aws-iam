output "name" {
  value = aws_iam_role.this.name

  depends_on = [aws_iam_role.this]
}
