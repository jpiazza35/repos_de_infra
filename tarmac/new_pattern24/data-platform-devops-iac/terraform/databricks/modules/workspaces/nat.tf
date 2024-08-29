# ## Private NAT Gateway for access to the internet via the TGW. Must be attached to the routable Subnet(10.x.x.0/24)
# resource "aws_nat_gateway" "private" {
#   for_each          = toset([var.private_subnet_ids[1]])
#   connectivity_type = "private"
#   subnet_id         = each.value
#   tags = merge(
#     var.tags,
#     {
#       Name = "private-vpc-ngw"
#     }
#   )
# }

# resource "aws_route" "private_nat" {
#   for_each               = toset([var.private_subnet_ids[1]])
#   route_table_id         = data.aws_vpc.vpc.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.private[each.key].id

# }
