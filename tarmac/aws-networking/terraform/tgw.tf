# Create organization Transit Gateway
module "tgw" {
  providers = {
    aws      = aws
    aws.use1 = aws.use1
    aws.use2 = aws.use2
  }
  source      = "./modules/tgw"
  name        = "cn-tgw-${data.aws_region.current.name}"
  description = "Organization core Transit Gateway"

  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true
  share_tgw                              = true
  ram_allow_external_principals          = false
  ram_principals = [
    var.org_arn
  ]

  use2-cidr = terraform.workspace == "tgw" ? format("%s/%s", data.phpipam_subnet.nova[0].subnet_address, data.phpipam_subnet.nova[0].subnet_mask) : null

  tags = merge(
    var.tags,
    {
      Environment  = "shared_services"
      App          = "tgw"
      Resource     = "Managed by Terraform"
      Description  = "Transit Gateway Configuration"
      Team         = "DevOps"
      "cn:service" = "infrastructure"
    }
  )
}

