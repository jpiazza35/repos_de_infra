# / resource
resource "aws_api_gateway_integration" "root" {
  count = var.has_root_endpoint ? length(var.api_gw_root_endpoint_methods) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method = var.api_gw_root_endpoint_methods[count.index]
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}"

  request_parameters = var.no_mtls_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = var.api_gw_root_endpoint_methods[count.index]

  depends_on = [
    aws_api_gateway_method.root
  ]
}

# The integrations for the GET method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_get" {
  count = var.uses_get_method ? length(aws_api_gateway_method.proxy_get.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_get[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_get[count.index].http_method
}

# The integrations for the PUT method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_put" {
  count = var.uses_put_method ? length(aws_api_gateway_method.proxy_put.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_put[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_put[count.index].http_method
}

# The integrations for the POST method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_post" {
  count = var.uses_post_method ? length(aws_api_gateway_method.proxy_post.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_post[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_post[count.index].http_method
}

# The integrations for the DELETE method on the proxy catch all endpoints that are after level 2.
resource "aws_api_gateway_integration" "proxy_delete" {
  count = var.uses_delete_method ? length(aws_api_gateway_method.proxy_delete.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_delete[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_delete[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_any" {
  count = var.uses_any_method ? length(aws_api_gateway_method.proxy_any.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_any[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_any[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_head" {
  count = var.uses_head_method ? length(aws_api_gateway_method.proxy_head.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_head[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_head[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_options" {
  count = var.uses_options_method ? length(aws_api_gateway_method.proxy_options.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_options[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_options[count.index].http_method
}

resource "aws_api_gateway_integration" "proxy_patch" {
  count = var.uses_patch_method ? length(aws_api_gateway_method.proxy_patch.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy[count.index].id
  http_method = aws_api_gateway_method.proxy_patch[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_patch[count.index].http_method
}

resource "aws_api_gateway_integration" "api_gw_2nd_level_get" {
  count       = var.create_2nd_level_methods && var.uses_get_method ? length(aws_api_gateway_method.api_gw_2nd_level_get.*.id) : 0
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  http_method = aws_api_gateway_method.api_gw_2nd_level_get[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}"

  request_parameters = var.mtls ? var.mtls_api_gw_request_parameters : var.no_mtls_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.api_gw_2nd_level_get[count.index].http_method

  depends_on = [
    aws_api_gateway_method.api_gw_2nd_level_get
  ]
}

resource "aws_api_gateway_integration" "api_gw_2nd_level_post" {
  count       = var.create_2nd_level_methods && var.uses_post_method ? length(aws_api_gateway_method.api_gw_2nd_level_post.*.id) : 0
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  http_method = aws_api_gateway_method.api_gw_2nd_level_post[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}"

  request_parameters = var.mtls ? var.mtls_api_gw_request_parameters : var.no_mtls_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.api_gw_2nd_level_post[count.index].http_method

  depends_on = [
    aws_api_gateway_method.api_gw_2nd_level_post
  ]
}

resource "aws_api_gateway_integration" "api_gw_2nd_level_head" {
  count       = var.create_2nd_level_methods && var.uses_head_method ? length(aws_api_gateway_method.api_gw_2nd_level_head.*.id) : 0
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  http_method = aws_api_gateway_method.api_gw_2nd_level_head[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.api_gw_2nd_level[count.index].path_part}"

  request_parameters = var.mtls ? var.mtls_api_gw_request_parameters : var.no_mtls_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.api_gw_2nd_level_head[count.index].http_method

  depends_on = [
    aws_api_gateway_method.api_gw_2nd_level_head
  ]
}

# Internal endpoints
resource "aws_api_gateway_integration" "internal_get" {
  count       = var.has_internal_endpoints ? length(aws_api_gateway_method.internal_get.*.id) : 0
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.internal[count.index].id
  http_method = aws_api_gateway_method.internal_get[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${var.internal_api_gw_endpoints[count.index]}"

  request_parameters = var.no_mtls_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.internal_get[count.index].http_method

  depends_on = [
    aws_api_gateway_method.internal_get
  ]
}

# The integration for the GET method on the proxy catch all endpoints used for the internal API GW endpoints
resource "aws_api_gateway_integration" "proxy_internal_get" {
  count = var.create_internal_proxy_endpoints ? length(aws_api_gateway_method.proxy_internal_get.*.id) : 0

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy_internal[count.index].id
  http_method = aws_api_gateway_method.proxy_internal_get[count.index].http_method
  type        = "HTTP_PROXY"
  uri         = "https://example-account.${var.app_public_dns_name}:${var.i_lbs_listener_port}/${aws_api_gateway_resource.internal[count.index].path_part}/{proxy}"

  cache_key_parameters = [
    "method.request.path.proxy"
  ]

  request_parameters = var.mtls ? var.mtls_proxy_api_gw_request_parameters : var.no_mtls_proxy_api_gw_request_parameters

  connection_type = "VPC_LINK"
  connection_id   = var.create_lb_resources ? aws_api_gateway_vpc_link.api_gw[0].id : var.api_gw_vpc_link_id

  integration_http_method = aws_api_gateway_method.proxy_internal_get[count.index].http_method
}