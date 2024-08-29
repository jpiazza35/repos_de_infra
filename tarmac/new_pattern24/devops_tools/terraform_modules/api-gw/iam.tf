resource "aws_iam_role" "api_gw" {
  count              = var.create_api_gw_iam ? 1 : 0
  name               = "${var.tags["Environment"]}-api-gw-role"
  assume_role_policy = var.assume_api_gw_role_policy
  description        = "This role is used in the API GW settings to allow Cloudwatch logs permissions."

  tags = var.tags
}

# IAM policy allowing API GW IAM role to send logs to Cloudwatch
resource "aws_iam_policy" "api_gw" {
  count       = var.create_api_gw_iam ? 1 : 0
  name        = "${var.tags["Environment"]}-allow-cw-logs-api-gw"
  description = "This policy gives Cloudwatch logs permissions to the API GW IAM role."
  path        = "/"
  policy      = data.template_file.cw_logs_api_gw_role.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "api_gw" {
  count      = var.create_api_gw_iam ? 1 : 0
  role       = aws_iam_role.api_gw[0].name
  policy_arn = aws_iam_policy.api_gw[0].arn
}