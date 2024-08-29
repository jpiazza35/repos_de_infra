data "archive_file" "sql_automation" {
  type        = "zip"
  output_path = "sql_automation_lambda.zip"
  source_dir  = "${path.module}/sql_automation_lambda/"
}

resource "aws_lambda_function" "sql_automation" {
  function_name    = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-sql-automation"
  description      = "This function is used to automate the execution of SQL commands to RDS."
  handler          = "sql_automation.lambda_handler"
  filename         = data.archive_file.sql_automation.output_path
  source_code_hash = filebase64sha256(data.archive_file.sql_automation.output_path)
  role             = aws_iam_role.sql_automation.arn
  runtime          = var.lambdas_py_runtime
  timeout          = var.lambdas_timeout
  memory_size      = var.lambdas_memory_size

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.rds_lambdas.id]
  }

  environment {
    variables = {
      DB_HOSTNAME = aws_db_instance.postgresql.address
      DB_USERNAME = var.db_iam_auth_username
      DB_NAME     = var.db_database
      DB_PORT     = var.db_port
      REGION      = var.region
      S3_BUCKET   = aws_s3_bucket.sql_automation.bucket
      SQL_FILE    = var.sql_file
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.sql_automation_vpc,
    aws_cloudwatch_log_group.sql_automation,
  ]

  tags = var.tags
}

resource "aws_lambda_permission" "sql_automation" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sql_automation.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.sql_automation.arn
}
