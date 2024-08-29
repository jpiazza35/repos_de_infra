resource "aws_api_gateway_stage" "stage" {
  deployment_id         = aws_api_gateway_deployment.deployment.id
  rest_api_id           = aws_api_gateway_rest_api.api_gw.id
  stage_name            = var.api_gw_stage_name
  cache_cluster_enabled = var.api_gw_stage_cache_cluster_enabled
  cache_cluster_size    = var.api_gw_stage_cache_cluster_size

  depends_on = [
    aws_cloudwatch_log_group.api_gw
  ]
}

resource "aws_api_gateway_method_settings" "api_gw" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    caching_enabled      = var.api_gw_methods_caching_enabled
    cache_data_encrypted = var.api_gw_methods_cache_data_encrypted
  }
}