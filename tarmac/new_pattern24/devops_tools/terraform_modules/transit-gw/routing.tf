# resource "aws_ec2_transit_gateway_route" "aws_to_example-account" {
#   count                          = var.create_transit_gw_routes ? 1 : 0
#   destination_cidr_block         = var.static_route_cidr_dev
#   transit_gateway_attachment_id  = var.s2s_vpn_attachment_dev
#   transit_gateway_route_table_id = element(concat(aws_ec2_transit_gateway.example-account_networking_tgw.*.association_default_route_table_id, tolist([""])), 0)
# }