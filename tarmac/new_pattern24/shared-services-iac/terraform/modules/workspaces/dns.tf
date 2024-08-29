resource "aws_vpc_dhcp_options" "dns_resolver" {

  domain_name_servers = aws_directory_service_directory.ds.dns_ip_addresses
  domain_name         = var.domain_name

  tags = merge(
    var.tags,
    {
      Name = var.app
    }
  )

}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {

  vpc_id          = data.aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id

}
