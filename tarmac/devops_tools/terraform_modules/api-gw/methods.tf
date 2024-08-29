# The methods set on the / endpoints
resource "aws_api_gateway_method" "root" {
  count = var.has_root_endpoint ? length(var.api_gw_root_endpoint_methods) : 0

  authorization = "NONE"
  http_method   = var.api_gw_root_endpoint_methods[count.index]
  resource_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
}

# The GET method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_get" {
  count = var.uses_get_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "GET"
  resource_id   = var.create_root_proxy_endpoint ? aws_api_gateway_resource.proxy_root[count.index].id : aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The PUT method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_put" {
  count = var.uses_put_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The POST method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_post" {
  count = var.uses_post_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The DELETE method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_delete" {
  count = var.uses_delete_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The ANY method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_any" {
  count = var.uses_any_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The HEAD method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_head" {
  count = var.uses_head_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "HEAD"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The OPTIONS method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_options" {
  count = var.uses_options_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# The PATCH method on the proxy catch all endpoints
resource "aws_api_gateway_method" "proxy_patch" {
  count = var.uses_patch_method ? length(aws_api_gateway_resource.api_gw_2nd_level.*.id) : 0

  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.proxy[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method" "api_gw_2nd_level_get" {
  count         = var.create_2nd_level_methods && var.uses_get_method ? length(var.api_gw_2nd_level_endpoints) : 0
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_method" "api_gw_2nd_level_post" {
  count         = var.create_2nd_level_methods && var.uses_post_method ? length(var.api_gw_2nd_level_endpoints) : 0
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_method" "api_gw_2nd_level_head" {
  count         = var.create_2nd_level_methods && var.uses_head_method ? length(var.api_gw_2nd_level_endpoints) : 0
  authorization = "NONE"
  http_method   = "HEAD"
  resource_id   = aws_api_gateway_resource.api_gw_2nd_level[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
}

# The methods set on the internal endpoints
resource "aws_api_gateway_method" "internal_get" {
  count         = var.has_internal_endpoints ? length(var.internal_api_gw_endpoints) : 0
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.internal[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
}

# The proxy+ set on the internal endpoints
resource "aws_api_gateway_method" "proxy_internal_get" {
  count         = var.create_internal_proxy_endpoints ? length(var.internal_api_gw_endpoints) : 0
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.proxy_internal[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "ERROR"
  }
}
