# Create the TGW Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgwa" {
  count = var.attach_to_tgw ? 1 : 0

  transit_gateway_id = var.org_tgw_id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = aws_subnet.transit[*].id

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s", var.aws_account_name, aws_vpc.vpc.tags["Name"])
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}
