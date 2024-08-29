# The GET method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_get" {
  count = var.uses_get_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The PUT method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_put" {
  count = var.uses_put_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The POST method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_post" {
  count = var.uses_post_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The DELETE method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_delete" {
  count = var.uses_delete_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The ANY method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_any" {
  count = var.uses_any_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The HEAD method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_head" {
  count = var.uses_head_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "HEAD"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The OPTIONS method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_options" {
  count = var.uses_options_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The PATCH method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_root_patch" {
  count = var.uses_patch_method && var.create_root_proxy_endpoint ? length(aws_api_gateway_resource.proxy_root.*.id) : 0

  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.proxy_root[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}