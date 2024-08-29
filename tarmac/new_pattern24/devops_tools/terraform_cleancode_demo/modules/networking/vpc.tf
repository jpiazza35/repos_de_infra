resource "aws_vpc" "main" {
  cidr_block           = var.args.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.args.env}-${var.args.project}-${var.args.product}-${var.args.name}-vpc"
  }
}