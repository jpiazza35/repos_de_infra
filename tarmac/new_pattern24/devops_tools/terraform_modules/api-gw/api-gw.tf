resource "aws_api_gateway_rest_api" "api_gw" {
  name = "${var.tags["Environment"]}-${var.tags["Application"]}-api"

  disable_execute_api_endpoint = true

  binary_media_types = var.binary_media_types
  tags               = var.tags
}
