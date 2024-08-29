### Resources for a Locally Routed CIDR Range with a Private NAT Gateway to be used by Kubernetes

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count      = var.enable_secondary_cidr ? 1 : 0
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_parameters["networking"]["secondary_cidr_block"]
}
