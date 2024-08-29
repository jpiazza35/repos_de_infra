resource "aws_subnet" "example-account_private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.example-account_vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Product"]}-${var.tags["Application"]}-${var.tags["Service"]}-${element(var.availability_zones, count.index)}-private-subnet-${count.index + 1}-${var.tags["Environment"]}"

    },
  )
}

resource "aws_subnet" "example-account_public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.example-account_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Product"]}-${var.tags["Application"]}-${var.tags["Service"]}-${element(var.availability_zones, count.index)}-public-subnet-${count.index + 1}-${var.tags["Environment"]}"
    },
  )
}
