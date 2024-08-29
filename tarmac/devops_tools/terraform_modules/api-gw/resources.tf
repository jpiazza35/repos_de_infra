# The internally accessible api gw endpoints
resource "aws_api_gateway_resource" "internal" {
  count       = var.has_internal_endpoints ? length(var.internal_api_gw_endpoints) : 0
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = var.internal_api_gw_endpoints[count.index]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
}

# The 2nd level API GW endpoints defined in list variable api_gw_2nd_level_endpoints in main.tf
resource "aws_api_gateway_resource" "api_gw_2nd_level" {
  count       = var.create_2nd_level_endpoints ? length(var.api_gw_2nd_level_endpoints) : 0
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = var.api_gw_2nd_level_endpoints[count.index]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_resource" "proxy" {
  count       = var.create_2nd_level_endpoints ? length(var.api_gw_2nd_level_endpoints) : 0
  parent_id   = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  path_part   = var.proxy_catch_all
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_resource" "proxy_root" {
  count       = var.create_root_proxy_endpoint ? 1 : 0
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = var.proxy_catch_all
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_resource" "proxy_internal" {
  count       = var.create_internal_proxy_endpoints ? length(var.internal_api_gw_endpoints) : 0
  parent_id   = aws_api_gateway_resource.internal[count.index].id
  path_part   = var.proxy_catch_all
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
}
