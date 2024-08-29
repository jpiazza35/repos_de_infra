data "archive_file" "source" {
  type        = "zip"
  output_path = "${path.module}/${local.source_file_compress_name}"
  source_file = "${path.module}/${local.source_file_location}"
}

resource "null_resource" "dependency" {
  triggers = {
    source_code_file = filemd5(data.archive_file.source.source_file)
  }

  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/${local.dependency_script_location}"

    environment = {
      PATH_DEPENDENCY = "${path.module}/scripts"
      FILE_NAME       = local.dependency_file_name
    }
  }

  depends_on = [data.archive_file.source]
}

resource "aws_lambda_function" "notification_lambda" {
  function_name = local.lambda_resource_name
  role          = aws_iam_role.this.arn
  memory_size   = var.lambda_request_memory_size
  environment {
    variables = {
      LAMBDA_SLACK_PROJECT = var.lambda_project
      LAMBDA_SLACK_WEBHOOK = jsondecode(data.aws_secretsmanager_secret_version.slack_webhook_secret_version.secret_string)["SLACK_WEBHOOK"]
    }
  }
  handler          = "main.alarm_notifications_handler"
  runtime          = "python3.9"
  layers           = [aws_lambda_layer_version.lambda_layer.arn]
  architectures    = ["x86_64"]
  filename         = data.archive_file.source.output_path
  source_code_hash = data.archive_file.source.output_base64sha256
  tags = {
    environment : var.lambda_environment
    project : var.lambda_project
    name : local.lambda_resource_name
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name               = "alarm-lambda-dependencies-layer-${var.lambda_environment}"
  description              = "Alarm Layer where the dependencies will be installed"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.9"]
  s3_bucket                = aws_s3_bucket.dependencies_store.bucket
  s3_key                   = local.dependency_file_name
  depends_on               = [aws_s3_object.dependency_file_upload]
}
