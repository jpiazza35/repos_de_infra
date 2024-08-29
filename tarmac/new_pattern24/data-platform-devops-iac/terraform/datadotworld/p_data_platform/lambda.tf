resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.common_properties.environment}-${var.lambda_properties.function_name}"
  description      = var.lambda_properties.description
  handler          = var.lambda_properties.handler
  filename         = data.archive_file.lambda_archive.output_path
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  architectures    = [var.lambda_properties.architectures]
  runtime          = var.lambda_properties.runtime_version
  timeout          = var.lambda_properties.timeout
  memory_size      = var.lambda_properties.memory_size
  ephemeral_storage {
    size = var.lambda_properties.ephemeral_storage
  }
  environment {
    variables = {
      DW_API_TOKEN = data.vault_generic_secret.prod-redshift.data["rw-api-token"]
    }
  }
}

# This resource triggers deployment of the lambda function only if there are changes in the code or requirements.
resource "null_resource" "install_lambda" {
  triggers = {
    lambda_code_hash = filemd5("${path.root}/lambda/run_task.py")
  }
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  output_path = "${path.root}/lambda/lambda.zip"
  source_dir  = "${path.root}/lambda/"
  depends_on  = [null_resource.install_lambda]
}

## Lambda role and permission
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

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
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ecs:ListServices",
          "ecs:ListServicesByNamespace",
          "ecs:RunTask",
          "ecs:ListAttributes",
          "ecs:ListTasks",
          "ecs:ListTaskDefinitionFamilies",
          "ecs:ListContainerInstances",
          "ecs:ListTaskDefinitions",
          "ecs:ListClusters",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
