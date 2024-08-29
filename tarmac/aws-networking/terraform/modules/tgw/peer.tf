## TGW Cross Region Peering
resource "aws_ec2_transit_gateway_peering_attachment" "peer" {
  count                   = terraform.workspace == "tgw-ohio" ? 1 : 0
  peer_region             = data.aws_region.current.name == "us-east-2" ? "us-east-1" : data.aws_region.current.name
  peer_transit_gateway_id = data.aws_ec2_transit_gateway.primary_tgw.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name           = "cn-tgw-us-east-1"
    sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "peer" {
  count = terraform.workspace == "tgw" ? 1 : 0

  transit_gateway_attachment_id = data.aws_ec2_transit_gateway_peering_attachment.peer.id

  tags = {
    Name           = "cn-tgw-us-east-2"
    sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "peer" {
  count                          = terraform.workspace == "tgw" ? 1 : 0
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

## TGW Routes
resource "aws_ec2_transit_gateway_route" "primary" {
  count                          = terraform.workspace == "tgw" ? 1 : 0
  destination_cidr_block         = var.use2-cidr ## Connect to all US-EAST-2 resources via the TGW
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.peer[count.index].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

resource "aws_ec2_transit_gateway_route" "peer" {
  count                          = terraform.workspace == "tgw-ohio" ? 1 : 0
  destination_cidr_block         = "10.0.0.0/8" ## Connect to all US-EAST-1 resources and on-prem via the TGW
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer[count.index].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

