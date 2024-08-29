resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name       = "vpc-${var.tags["env"]}-${var.tags["vpc"]}"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "vpc"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}
