resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    {
      Name           = var.name,
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}
