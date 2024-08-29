data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ec2_transit_gateway" "primary_tgw" {
  provider = aws.use1
  filter {
    name = "owner-id"
    values = [
      data.aws_caller_identity.current.account_id
    ]
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "peer" {
  provider = aws.use2
  tags = {
    Name = "cn-tgw-us-east-1"
  }
}

