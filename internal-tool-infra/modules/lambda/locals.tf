locals {
  source_file_compress_name  = "source.zip"
  source_file_location       = "scripts/main.py"
  dependency_script_location = "scripts/dependency.sh"
  dependency_file_name       = "lambda-dependencies.zip"
  dependency_file_location   = "scripts/${local.dependency_file_name}"

  lambda_role_name          = "AlarmNotificationLambdaRole-${var.lambda_environment}"
  lambda_resource_name      = "alarm-notification-lambda-${var.lambda_environment}"
  s3_bucket_dependency_name = "alarm-lambda-dependencies-${var.lambda_environment}"
  sns_topic_name            = "alarm-notification-topic-${var.lambda_environment}"
}
