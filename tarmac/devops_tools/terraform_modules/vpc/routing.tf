resource "aws_route_table" "example-account_private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.example-account_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Product"]}-${var.tags["Application"]}-${var.tags["Service"]}-private-rtb-${count.index + 1}-${var.tags["Environment"]}"
    },
  )
}

resource "aws_route_table_association" "example-account_private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.example-account_private.*.id, count.index)
  route_table_id = element(aws_route_table.example-account_private.*.id, count.index)
}

resource "aws_route_table" "example-account_public" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.example-account_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Product"]}-${var.tags["Application"]}-${var.tags["Service"]}-public-rtb-${count.index + 1}-${var.tags["Environment"]}"
    },
  )
}

resource "aws_route_table_association" "example-account_public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.example-account_public.*.id, count.index)
  route_table_id = element(aws_route_table.example-account_public.*.id, count.index)
}

resource "aws_route" "private_to_example-account_1" {
  count = var.create_example-account_on_prem_routes ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.example-account_private.*.id, count.index)
  destination_cidr_block = var.example-account_on_prem1
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_route_table.example-account_private]
}

resource "aws_route" "private_to_example-account_2" {
  count = var.create_example-account_on_prem_routes ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.example-account_private.*.id, count.index)
  destination_cidr_block = var.example-account_on_prem2
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_route_table.example-account_private]
}

resource "aws_route" "open_search_routes" {
  count = var.create_open_search_routes ? length(var.private_subnets) * length(var.open_search_cidr) : 0

  route_table_id         = element(local.os_routes, count.index)[0]
  destination_cidr_block = element(local.os_routes, count.index)[1]
  transit_gateway_id     = var.transit_gateway_id
  depends_on             = [aws_route_table.example-account_private]
}