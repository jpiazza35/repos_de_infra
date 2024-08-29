resource "aws_lambda_function" "redis_clean_up" {
  count         = var.create_ci_cd_lambdas ? 1 : 0
  function_name = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-clean-up"
  description   = "This function is used to flush redis cache."
  handler       = "com.example-account.aws.lambda.redis.clean.up.AwsRedisCleanUpLambda::handleRequest"
  s3_bucket     = var.ci_cd_lambdas_source_code_s3_bucket
  s3_key        = aws_s3_bucket_object.redis_clean_up_source[count.index].key
  role          = aws_iam_role.redis_clean_up[count.index].arn
  runtime       = var.lambdas_java_runtime
  timeout       = var.lambdas_timeout
  memory_size   = var.lambdas_memory_size

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.redis_lambdas[count.index].id]
  }

  environment {
    variables = {
      REDIS_HOST     = aws_elasticache_replication_group.card_ranges.configuration_endpoint_address
      REDIS_PASSWORD = var.redis_app_username_password
      REDIS_PORT     = aws_elasticache_replication_group.card_ranges.port
      REDIS_USERNAME = var.redis_app_username
      REDIS_USE_SSL  = true
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.redis_clean_up_vpc,
    aws_cloudwatch_log_group.redis_clean_up,
  ]

  tags = var.tags
}
