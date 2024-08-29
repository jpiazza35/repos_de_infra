resource "aws_route53_zone" "internal" {
  name    = "${var.environment}.${var.private_dns}"
  comment = "Internal DNS zone to use within services"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = merge(
    var.vpc_tags,
    {
      Name = "${var.environment}-private-r53-zone"
    },
  )
}

resource "aws_route53_zone" "public" {
  name    = var.public_dns
  comment = "The public DNS zone."

  tags = merge(
    var.vpc_tags,
    {
      Name = "${var.environment}-public-r53-zone"
    },
  )
}