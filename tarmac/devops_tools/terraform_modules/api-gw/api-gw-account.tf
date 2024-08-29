resource "aws_api_gateway_account" "api_gw" {
  count               = var.create_api_gw_iam ? 1 : 0
  cloudwatch_role_arn = aws_iam_role.api_gw[0].arn
}