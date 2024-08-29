data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "this" {
  name                = local.lambda_role_name
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy  = data.aws_iam_policy_document.this.json
  path                = "/"

  inline_policy {
    name = "ReadSlackCredentialsSecret"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "secretsmanager:GetSecretValue"
          Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:secret:*"
        },
      ]
    })
  }

  tags = {
    name        = local.lambda_role_name
    environment = var.lambda_environment
    project     = var.lambda_project
  }
}
