resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = var.app
  description = "This transforms databricks webhook from slack to trigger GHA"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.app
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"

}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "integration" {
  for_each                = var.api_gateway_integration
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  type                    = "HTTP"
  integration_http_method = "POST"
  uri                     = each.value.uri
  passthrough_behavior    = each.value.passthrough_behavior

  dynamic "request_parameters" {
    for_each = each.value.request_parameters
    content {
      name  = request_parameters.value.name
      value = request_parameters.value.value
    }
  }

  dynamic "request_templates" {
    for_each = each.value.request_templates
    content {
      key   = request_templates.value.key
      value = request_templates.value.value
    }
  }
}

resource "aws_api_gateway_integration_response" "mlflow" {
  rest_api_id = aws_api_gateway_rest_api.mlflow.id
  resource_id = aws_api_gateway_resource.mlflow.id
  http_method = aws_api_gateway_method.mlflow.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
EOF
  }
}

resource "aws_api_gateway_deployment" "mlflow" {
  rest_api_id = aws_api_gateway_rest_api.mlflow.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.mlflow.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "mlflow" {
  deployment_id = aws_api_gateway_deployment.mlflow.id
  rest_api_id   = aws_api_gateway_rest_api.mlflow.id
  stage_name    = "mlflow"
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.mlflow.id
  stage_name  = aws_api_gateway_stage.mlflow.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
