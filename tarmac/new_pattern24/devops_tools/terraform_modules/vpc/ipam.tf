resource "aws_vpc_ipam" "example-account_ipam" {
  operating_regions {
    region_name = var.region
  }
}

resource "aws_vpc_ipam_pool" "example-account_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.example-account_ipam.private_default_scope_id
  locale         = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "example-account_ipam_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.example-account_ipam_pool.id
  cidr         = var.cidr_block
}