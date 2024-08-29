resource "aws_lambda_function" "rds_clean_up" {
  count         = var.create_ci_cd_lambdas ? 1 : 0
  function_name = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-clean-up"
  description   = "This function is used to drop all tables in database in rds."
  handler       = "com.example-account.aws.lambda.rds.clean.up.AwsRdsCleanUpLambda::handleRequest"
  s3_bucket     = var.ci_cd_lambdas_source_code_s3_bucket
  s3_key        = aws_s3_bucket_object.rds_clean_up_source[count.index].key
  role          = aws_iam_role.rds_clean_up[count.index].arn
  runtime       = var.lambdas_java_runtime
  timeout       = var.lambdas_timeout
  memory_size   = var.lambdas_memory_size

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.rds_lambdas.id]
  }

  environment {
    variables = {
      RDS_JDBC_URL = "jdbc:postgresql://${aws_db_instance.postgresql.address}:${aws_db_instance.postgresql.port}/${var.db_database}?currentSchema=${var.db_database}"
      RDS_SCHEMA   = var.db_database
      RDS_USERNAME = var.db_iam_auth_username
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.rds_clean_up_vpc,
    aws_cloudwatch_log_group.rds_clean_up,
  ]

  tags = var.tags
}
