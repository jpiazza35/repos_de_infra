resource "aws_subnet" "all" {
  for_each = { for idx, val in local.flat_subnets : "${val.subnet_group}-${val.availability_zone}" => val }

  cidr_block        = cidrsubnet(var.args.cidr_block, 8, index(local.flat_subnets, each.value))
  availability_zone = each.value.availability_zone
  vpc_id            = aws_vpc.main.id

  tags = {
    Name             = "${var.args.env}-${var.args.project}-${var.args.product}-${var.args.name}-${each.value.subnet_group}-${each.value.zone_letter}"
    SubnetGroup      = each.value.subnet_group
    AvailabilityZone = each.value.availability_zone
  }
}