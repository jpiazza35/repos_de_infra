# The IAM role for the SQL automation Lambda function
resource "aws_iam_role" "sql_automation" {
  name               = "${var.tags["Environment"]}-${var.tags["Product"]}-sql-automation-lambda-role"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "This role is used by the SQL automation Lambda function."

  tags = var.tags
}

# IAM policy allowing the SQL automation Lambda function to access RDS via IAM auth
resource "aws_iam_policy" "sql_automation_iam_auth" {
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-sql-automation-lambda-iam-auth"
  description = "This policy allows the SQL automation Lambda access AWS RDS via IAM auth."
  path        = "/"
  policy      = data.template_file.rds_iam_auth.rendered

  tags = var.tags
}

# IAM policy allowing the SQL automation Lambda function to access the SQL scripts S3 bucket
resource "aws_iam_policy" "sql_automation_role_s3" {
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-sql-automation-lambda-s3-access"
  description = "This policy allows the SQL automation Lambda to access the SQL scripts S3 bucket."
  path        = "/"
  policy      = data.template_file.sql_automation_role_s3.rendered

  tags = var.tags
}

# Attach AWSLambdaVPCAccessExecutionRole policy to the Lambda IAM roles
resource "aws_iam_role_policy_attachment" "sql_automation_vpc" {
  role       = aws_iam_role.sql_automation.name
  policy_arn = var.lambda_vpc_execution_policy
}

# Attach IAM policy for accessing CW
resource "aws_iam_role_policy_attachment" "sql_automation_cw_access" {
  role       = aws_iam_role.sql_automation.name
  policy_arn = aws_iam_policy.rds_lambdas_cw_access.arn
}

resource "aws_iam_role_policy_attachment" "sql_automation_iam_auth" {
  role       = aws_iam_role.sql_automation.name
  policy_arn = aws_iam_policy.sql_automation_iam_auth.arn
}

resource "aws_iam_role_policy_attachment" "sql_automation_role_s3" {
  role       = aws_iam_role.sql_automation.name
  policy_arn = aws_iam_policy.sql_automation_role_s3.arn
}