# The IAM role for the Redis Clean-Up Lambda function
resource "aws_iam_role" "redis_clean_up" {
  count              = var.create_ci_cd_lambdas ? 1 : 0
  name               = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-clean-up-lambda-role"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "This role is used by the Redis clean-up Lambda function."

  tags = var.tags
}

# IAM policy allowing RDS Lambdas IAM roles access to Cloudwatch logs
resource "aws_iam_policy" "redis_lambdas_cw_access" {
  count       = var.create_ci_cd_lambdas ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-lambdas-cw-access"
  description = "This policy allows the Redis Lambda roles access to Cloudwatch."
  path        = "/"
  policy      = data.template_file.redis_lambdas_cw_access.rendered

  tags = var.tags
}

# Attach AWSLambdaVPCAccessExecutionRole policy to the Lambda IAM roles
resource "aws_iam_role_policy_attachment" "redis_clean_up_vpc" {
  count      = var.create_ci_cd_lambdas ? 1 : 0
  role       = aws_iam_role.redis_clean_up[count.index].name
  policy_arn = var.lambda_vpc_execution_policy
}

# Attach IAM policy for accessing CW
resource "aws_iam_role_policy_attachment" "redis_clean_up_cw_access" {
  count      = var.create_ci_cd_lambdas ? 1 : 0
  role       = aws_iam_role.redis_clean_up[count.index].name
  policy_arn = aws_iam_policy.redis_lambdas_cw_access[count.index].arn
}
