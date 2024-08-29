resource "aws_ec2_transit_gateway_vpc_attachment" "example-account_transitgw_attachment" {
  count              = var.create_transit_gw_vpc_attachment ? 1 : 0
  subnet_ids         = var.private_subnets
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id

  tags = {
    Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-transit-gw-attachment"

    Side = "Creator"
  }
}