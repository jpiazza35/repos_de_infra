resource "aws_ram_resource_share" "tgw" {
  count = var.share_tgw ? 1 : 0

  name                      = format("%s-share", aws_ec2_transit_gateway.tgw.tags["Name"])
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    var.tags,
    {
      Name           = format("%s-share", aws_ec2_transit_gateway.tgw.tags["Name"])
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

resource "aws_ram_resource_association" "tgw" {
  count = var.share_tgw ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.tgw.arn
  resource_share_arn = aws_ram_resource_share.tgw[0].id
}

resource "aws_ram_principal_association" "tgw" {
  count = var.share_tgw ? length(var.ram_principals) : 0

  principal          = element(var.ram_principals, count.index)
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}
