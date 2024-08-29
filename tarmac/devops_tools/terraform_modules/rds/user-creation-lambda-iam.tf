# The IAM role for the RDS user creation Lambda function
resource "aws_iam_role" "user_creation" {
  name               = "${var.tags["Environment"]}-${var.tags["Product"]}-user-creation-lambda-role"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "This role is used by the RDS user creation Lambda function."

  tags = var.tags
}

# IAM policy allowing RDS Lambdas IAM roles access to Cloudwatch logs
resource "aws_iam_policy" "rds_lambdas_cw_access" {
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-lambdas-cw-access"
  description = "This policy allows the RDS Lambda roles access to Cloudwatch."
  path        = "/"
  policy      = data.template_file.rds_lambdas_cw_access.rendered

  tags = var.tags
}

# Attach AWSLambdaVPCAccessExecutionRole policy to the Lambda IAM roles
resource "aws_iam_role_policy_attachment" "user_creation_vpc" {
  role       = aws_iam_role.user_creation.name
  policy_arn = var.lambda_vpc_execution_policy
}

# Attach IAM policy for accessing CW
resource "aws_iam_role_policy_attachment" "user_creation_cw_access" {
  role       = aws_iam_role.user_creation.name
  policy_arn = aws_iam_policy.rds_lambdas_cw_access.arn
}