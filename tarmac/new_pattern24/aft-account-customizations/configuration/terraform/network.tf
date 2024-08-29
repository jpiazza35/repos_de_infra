# Create local logging resources for account troubleshooters
resource "aws_s3_bucket" "flowlogs" {
  count  = local.create_vpc ? 1 : 0
  bucket = format("cn-flow-logs-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name)

  tags = merge(
    var.tags,
    {
      "cn:service"     = "storage",
      "cn:environment" = local.environment
    }
  )
}

# Set lifecycle on the local logging bucket
resource "aws_s3_bucket_lifecycle_configuration" "flowlogs" {
  count  = local.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.flowlogs[0].id

  rule {
    id = "expiration"
    filter {}
    expiration {
      days = 30
    }
    status = "Enabled"
  }
}

module "vpc" {
  source = "./modules/vpc"
  providers = {
    aws      = aws
    aws.logs = aws.ct-log-archive
    aws.mgmt = aws.ct-management
  }
  count = local.create_vpc ? 1 : 0

  aws_account_name = local.account_name

  vpc_cidr = coalesce(
    local.primary_cidr,
    format("%s/%s",
      phpipam_first_free_subnet.new_subnet[0].subnet_address,
      phpipam_first_free_subnet.new_subnet[0].subnet_mask
    )
  )

  enable_public_subnets = local.enable_public_subnets
  attach_to_tgw         = true
  enable_secondary_cidr = local.create_secondary_cidr
  flowlog_bucket_arn    = aws_s3_bucket.flowlogs[0].arn
  vpc_parameters        = var.vpc_parameters

  tags = merge(
    var.tags,
    {
      "cn:service"     = "infrastructure"
      "cn:environment" = local.environment
      Component        = "networking"
    }
  )
}
