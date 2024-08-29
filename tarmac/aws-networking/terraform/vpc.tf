module "vpc-primary" {
  source = "./modules/vpc"
  providers = {
    aws      = aws
    aws.logs = aws.log-archive
  }
  vpc_cidr = terraform.workspace == "tgw" ? format("%s/%d", data.phpipam_subnet.subnets.0.subnet_address, data.phpipam_subnet.subnets.0.subnet_mask) : format("%s/%s",
    phpipam_first_free_subnet.new_subnet[0].subnet_address,
    phpipam_first_free_subnet.new_subnet[0].subnet_mask
  )
  aws_account_name      = var.aws_account_name
  attach_to_tgw         = true
  org_tgw_id            = module.tgw.tgw.id
  name                  = "primary-vpc"
  endpoints             = var.endpoints
  enable_public_subnets = true
  enable_nat_gateways   = true

  tags = merge(
    var.tags,
    {
      Environment  = "shared_services"
      App          = "tgw"
      Resource     = "Managed by Terraform"
      Description  = "VPC Network Configuration"
      Team         = "DevOps"
      "cn:service" = "infrastructure"
    }
  )

}

module "vpc-inspection-internet" {
  source = "./modules/vpc"
  providers = {
    aws      = aws
    aws.logs = aws.log-archive
  }

  for_each = terraform.workspace == "tgw" ? toset(["us-east-1"]) : toset([])

  vpc_cidr                       = terraform.workspace == "tgw" ? "192.168.10.0/23" : "192.168.30.0/23"
  aws_account_name               = var.aws_account_name
  attach_to_tgw                  = true
  enable_public_subnets          = true
  enable_nat_gateways            = true
  org_tgw_id                     = module.tgw.tgw.id
  name                           = "internet-inspection-vpc"
  enable_default_rtb_propagation = false
  enable_default_rtb_association = false
  endpoints                      = var.endpoints

  tags = merge(
    var.tags,
    {
      Environment  = "shared_services"
      App          = "tgw"
      Resource     = "Managed by Terraform"
      Description  = "VPC Network Configuration"
      Team         = "DevOps"
      "cn:service" = "infrastructure"
    }
  )
}

module "vpc-inspection-internal" {
  source = "./modules/vpc"
  providers = {
    aws      = aws
    aws.logs = aws.log-archive
  }

  for_each = terraform.workspace == "tgw" ? toset(["us-east-1"]) : toset([])

  vpc_cidr                       = terraform.workspace == "tgw" ? "192.168.20.0/23" : "192.168.40.0/23"
  aws_account_name               = var.aws_account_name
  attach_to_tgw                  = true
  org_tgw_id                     = module.tgw.tgw.id
  name                           = "internal-inspection-vpc"
  enable_default_rtb_propagation = false
  enable_default_rtb_association = false
  endpoints                      = var.endpoints

  tags = merge(
    var.tags,
    {
      Environment  = "shared_services"
      App          = "tgw"
      Resource     = "Managed by Terraform"
      Description  = "VPC Network Configuration"
      Team         = "DevOps"
      "cn:service" = "infrastructure"
    }
  )
}
