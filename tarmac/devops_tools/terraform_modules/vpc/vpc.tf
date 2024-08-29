resource "aws_vpc" "example-account_vpc" {
  ipv4_ipam_pool_id                = aws_vpc_ipam_pool.example-account_ipam_pool.id
  ipv4_netmask_length              = var.netmask_length
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false
  depends_on = [
    aws_vpc_ipam_pool_cidr.example-account_ipam_cidr
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Moniker"]}-${var.tags["Product"]}-${var.tags["Application"]}-${var.tags["Service"]}-vpc-${var.tags["Environment"]}"
    },
  )
}
