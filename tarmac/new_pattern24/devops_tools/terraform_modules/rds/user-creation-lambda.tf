data "archive_file" "user_creation" {
  type        = "zip"
  output_path = "user_creation_lambda.zip"
  source_dir  = "${path.module}/user_creation_lambda/"
}

resource "aws_lambda_function" "user_creation" {
  function_name    = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-user-creation"
  description      = "This function is used to create the IAM auth user in the database."
  handler          = "user_creation.lambda_handler"
  filename         = data.archive_file.user_creation.output_path
  source_code_hash = filebase64sha256(data.archive_file.user_creation.output_path)
  role             = aws_iam_role.user_creation.arn
  runtime          = var.lambdas_py_runtime
  timeout          = var.lambdas_timeout
  memory_size      = var.lambdas_memory_size

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.rds_lambdas.id]
  }

  environment {
    variables = {
      DB_HOSTNAME          = "${var.tags["Environment"]}-${var.tags["Product"]}-postgres-db.${var.db_region_id}.${var.region}.rds.amazonaws.com"
      DB_USERNAME          = var.db_username
      DB_IAM_AUTH_USERNAME = var.db_iam_auth_username
      DB_PASSWORD          = var.db_password
      DB_NAME              = var.db_database
      DB_SCHEMA_NAME       = var.db_schema_name
      DB_PORT              = var.db_port
      DB_DA_CRS_SEQUENCE   = var.db_da_crs_sequence
      REGION               = var.region
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.user_creation_vpc,
    aws_cloudwatch_log_group.user_creation,
  ]

  tags = var.tags
}

resource "aws_lambda_permission" "user_creation" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_creation.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.alerts_sns_topic_arn
}

resource "aws_sns_topic_subscription" "user_creation" {
  topic_arn = var.alerts_sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.user_creation.arn
}
