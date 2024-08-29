# The integrations for the GET method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_root_get" {
  count = var.uses_get_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_get.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_get[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_get[count.index].http_method
}

# The integrations for the PUT method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_root_put" {
  count = var.uses_put_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_put.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_put[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_put[count.index].http_method
}

# The integrations for the POST method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_root_post" {
  count = var.uses_post_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_post.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_post[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_post[count.index].http_method
}

# The integrations for the DELETE method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_root_delete" {
  count = var.uses_delete_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_delete.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_delete[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_delete[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_root_any" {
  count = var.uses_get_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_any.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_any[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_any[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_root_head" {
  count = var.uses_head_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_head.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_head[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_head[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_root_options" {
  count = var.uses_options_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_options.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_options[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_options[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_root_patch" {
  count = var.uses_patch_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_method.proxy_root_patch.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_root[count.index].id
  http_method = aws_api_gateway_method.proxy_root_patch[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_root_patch[count.index].http_method
}