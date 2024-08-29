# The IAM role for the RDS clean-up Lambda function
resource "aws_iam_role" "rds_clean_up" {
  count              = var.create_ci_cd_lambdas ? 1 : 0
  name               = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-clean-up-lambda-role"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "This role is used by the RDS clean-up Lambda function."

  tags = var.tags
}

# IAM policy allowing the RDS clean-up Lambda function to access RDS via IAM auth
resource "aws_iam_policy" "rds_clean_up_iam_auth" {
  count       = var.create_ci_cd_lambdas ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-clean-up-lambda-iam-auth"
  description = "This policy allows the RDS clean-up Lambda access AWS RDS via IAM auth."
  path        = "/"
  policy      = data.template_file.rds_iam_auth.rendered

  tags = var.tags
}

# Attach AWSLambdaVPCAccessExecutionRole policy to the Lambda IAM roles
resource "aws_iam_role_policy_attachment" "rds_clean_up_vpc" {
  count      = var.create_ci_cd_lambdas ? 1 : 0
  role       = aws_iam_role.rds_clean_up[count.index].name
  policy_arn = var.lambda_vpc_execution_policy
}

# Attach IAM policy for accessing CW
resource "aws_iam_role_policy_attachment" "rds_clean_up_cw_access" {
  count      = var.create_ci_cd_lambdas ? 1 : 0
  role       = aws_iam_role.rds_clean_up[count.index].name
  policy_arn = aws_iam_policy.rds_lambdas_cw_access.arn
}

resource "aws_iam_role_policy_attachment" "rds_clean_up_iam_auth" {
  count      = var.create_ci_cd_lambdas ? 1 : 0
  role       = aws_iam_role.rds_clean_up[count.index].name
  policy_arn = aws_iam_policy.rds_clean_up_iam_auth[count.index].arn
}
