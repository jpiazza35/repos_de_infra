resource "aws_api_gateway_vpc_link" "api_gw" {
  count       = var.create_lb_resources ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-vpc-link"
  description = "${var.tags["Environment"]} ${var.tags["Product"]} VPC link."
  target_arns = [aws_lb.i_nlb[0].arn]

  tags = var.tags
}