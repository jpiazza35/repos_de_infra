resource "aws_api_gateway_method_response" "root_response_200" {
  count = var.has_root_endpoint ? length(var.api_gw_root_endpoint_methods) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method = var.api_gw_root_endpoint_methods[count.index]
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}