resource "aws_ec2_transit_gateway" "example-account_networking_tgw" {
  count = var.create_transit_gw ? 1 : 0

  description                    = "Transit Gateway for interconnecting VPCs and DataTrans on-prem infrastructure"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-transit-gw"

  }
}

resource "aws_ram_resource_share" "example-account_networking_share" {
  count = var.create_transit_gw ? 1 : 0
  name  = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-resource-share"

  tags = {
    Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-resource-share"
  }
}

resource "aws_ram_resource_association" "example-account_networking_association" {
  count              = var.create_transit_gw ? 1 : 0
  resource_arn       = element(concat(aws_ec2_transit_gateway.example-account_networking_tgw.*.arn, tolist([""])), 0)
  resource_share_arn = element(concat(aws_ram_resource_share.example-account_networking_share.*.arn, tolist([""])), 0)
}

resource "aws_ram_principal_association" "example-account_networking_principal_association" {
  count              = var.create_transit_gw ? length(var.example-account_organizations_arn) : 0
  principal          = element(var.example-account_organizations_arn, count.index)
  resource_share_arn = element(concat(aws_ram_resource_share.example-account_networking_share.*.arn, tolist([""])), 0)
}