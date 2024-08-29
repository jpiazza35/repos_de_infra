resource "aws_api_gateway_base_path_mapping" "api_gw" {
  api_id      = aws_api_gateway_rest_api.api_gw.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = var.mtls ? aws_api_gateway_domain_name.mtls[0].domain_name : aws_api_gateway_domain_name.no_mtls[0].domain_name
}

resource "aws_api_gateway_base_path_mapping" "ds" {
  count = var.mtls ? length(var.ds_cards_records) : 0

  api_id      = aws_api_gateway_rest_api.api_gw.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = var.mtls ? aws_api_gateway_domain_name.ds[count.index].domain_name : 0
}