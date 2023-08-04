output "name" {
  value = aws_iam_user.this.name

  depends_on = [aws_iam_user.this]
}
