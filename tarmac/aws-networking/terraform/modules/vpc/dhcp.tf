resource "aws_vpc_dhcp_options" "sca" {
  count       = var.name == "primary-vpc" ? 1 : 0
  domain_name = "sca.local"
  domain_name_servers = [
    "10.200.11.33",
    "10.200.12.33"
  ]
  ntp_servers = [
    "10.200.11.33",
    "10.200.12.33"
  ]

  tags = merge(
    var.tags,
    {
      Name           = "sca"
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

resource "aws_default_vpc_dhcp_options" "default" {
  tags = merge(
    var.tags,
    {
      Name           = "Default DHCP Option Set"
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  count           = var.name == "primary-vpc" ? 1 : 0
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.sca[0].id
}
