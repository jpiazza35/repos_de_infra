data "archive_file" "config_compliance_lambda" {
  count       = var.create_lambda_resources ? 1 : 0
  type        = "zip"
  output_path = "config_compliance_lambda.zip"
  source_file = "${path.module}/lambdas/config_compliance_lambda.py"
}

resource "aws_lambda_function" "config_compliance_lambda" {
  count            = var.create_lambda_resources ? 1 : 0
  function_name    = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-rules-compliance-events"
  description      = "Lambda function sending Config Rules Compliance Change events to Cloudwatch."
  handler          = "config_compliance_lambda.lambda_handler"
  filename         = data.archive_file.config_compliance_lambda[count.index].output_path
  source_code_hash = filebase64sha256(data.archive_file.config_compliance_lambda[count.index].output_path)
  role             = aws_iam_role.config_compliance_lambda[count.index].arn
  runtime          = "python3.8"
  timeout          = 60

  depends_on = [
    aws_iam_role_policy_attachment.config_compliance_lambda
  ]

  tags = var.tags
}

### IAM configs ###

# The IAM role for the Config rules compliance status Lambda function
resource "aws_iam_role" "config_compliance_lambda" {
  count              = var.create_lambda_resources ? 1 : 0
  name               = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-rules-compliance-lambda"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "IAM Role for the Config rules compliance Lambda function."

  tags = var.tags
}

resource "aws_iam_policy" "config_compliance_lambda" {
  count       = var.create_lambda_resources ? 1 : 0
  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-rules-compliance-lambda"
  description = "This policy allows the Config rules compliance Lambda IAM role access Cloudwatch services."
  path        = "/"
  policy      = data.template_file.config_compliance_lambda.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config_compliance_lambda" {
  count      = var.create_lambda_resources ? 1 : 0
  role       = aws_iam_role.config_compliance_lambda[count.index].name
  policy_arn = aws_iam_policy.config_compliance_lambda[count.index].arn
}