resource "aws_vpc_dhcp_options" "sca" {
  domain_name = "sca.local"
  domain_name_servers = [
    "10.200.11.33",
    "10.200.12.33",
    "AmazonProvidedDNS"
  ]
  ntp_servers = [
    "10.200.11.33",
    "10.200.12.33"
  ]

  tags = merge(
    var.tags,
    {
      Name           = "sca"
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}

resource "aws_default_vpc_dhcp_options" "default" {
  tags = merge(
    var.tags,
    {
      Name           = "Default DHCP Option Set"
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}

## Do not associate the sca dhcp options with the default vpc unless needed

# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
#   vpc_id          = aws_vpc.vpc.id
#   dhcp_options_id = aws_vpc_dhcp_options.sca.id
# }
