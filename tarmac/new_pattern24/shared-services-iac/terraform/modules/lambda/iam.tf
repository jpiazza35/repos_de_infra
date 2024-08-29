resource "aws_iam_role" "lambda_role" {
  name = "${var.properties.function_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  dynamic "inline_policy" {
    for_each = var.properties.inline_policies
    content {
      name   = inline_policy.value.name
      policy = jsonencode(inline_policy.value.policy)
    }
  }
}
