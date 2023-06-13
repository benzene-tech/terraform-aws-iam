output "name" {
  value = aws_iam_policy.this.name

  depends_on = [aws_iam_policy.this]
}
