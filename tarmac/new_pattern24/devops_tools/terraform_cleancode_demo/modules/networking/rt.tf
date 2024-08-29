resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.args.env}-${var.args.project}-${var.args.product}-${var.args.name}-public-rt"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = { for idx, val in local.flat_subnets : "${val.subnet_group}-${val.availability_zone}" => val if val.subnet_group == "public" }

  subnet_id      = aws_subnet.all[each.key].id
  route_table_id = aws_route_table.public.id
}