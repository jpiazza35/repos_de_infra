resource "aws_api_gateway_rest_api_policy" "api_gw" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  policy = var.api_gw_policy
}