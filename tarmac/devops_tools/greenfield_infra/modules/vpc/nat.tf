resource "aws_route" "nat_routes" {
  count                  = var.nat ? length(var.private_subnets) : 0
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id = aws_nat_gateway.private[0].id
}

resource "aws_eip" "nat_eip" {
  count = var.nat ? length(var.private_subnets) : 0
  vpc   = true
}

resource "aws_nat_gateway" "private" {
  count = 1 # number of NAT GWs to be created

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    # Name       = format("%s Private", var.project)
    Name       = "nat-${var.tags["env"]}-${var.tags["vpc"]}-${element(var.availability_zones, count.index)}-private"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "route table"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}
