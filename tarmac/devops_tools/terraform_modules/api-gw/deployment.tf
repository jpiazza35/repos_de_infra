resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.api_gw,
      aws_api_gateway_resource.api_gw_2nd_level.*.id,
      aws_api_gateway_resource.internal.*.id,
      aws_api_gateway_rest_api.api_gw.root_resource_id,
      aws_api_gateway_integration.root,
      aws_api_gateway_integration.proxy_get,
      aws_api_gateway_integration.proxy_put,
      aws_api_gateway_integration.proxy_post,
      aws_api_gateway_integration.proxy_delete,
      aws_api_gateway_integration.proxy_root_get,
      aws_api_gateway_integration.proxy_root_put,
      aws_api_gateway_integration.proxy_root_post,
      aws_api_gateway_integration.proxy_root_delete,
      aws_api_gateway_integration.api_gw_2nd_level_get,
      aws_api_gateway_integration.api_gw_2nd_level_post,
      aws_api_gateway_method.api_gw_2nd_level_get,
      aws_api_gateway_method.api_gw_2nd_level_post,
      aws_api_gateway_method.internal_get,
      aws_api_gateway_integration.proxy_internal_get,
      var.api_gw_policy
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.root,
    aws_api_gateway_integration.proxy_get,
    aws_api_gateway_integration.proxy_put,
    aws_api_gateway_integration.proxy_post,
    aws_api_gateway_integration.proxy_delete,
    aws_api_gateway_integration.proxy_root_get,
    aws_api_gateway_integration.proxy_root_put,
    aws_api_gateway_integration.proxy_root_post,
    aws_api_gateway_integration.proxy_root_delete,
    aws_api_gateway_integration.api_gw_2nd_level_get,
    aws_api_gateway_integration.api_gw_2nd_level_post,
    aws_api_gateway_method.api_gw_2nd_level_get,
    aws_api_gateway_method.api_gw_2nd_level_post,
    aws_api_gateway_method.internal_get,
    aws_api_gateway_integration.proxy_internal_get,
    var.api_gw_policy
  ]
}
