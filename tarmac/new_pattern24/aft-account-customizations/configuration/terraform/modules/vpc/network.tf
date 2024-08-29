resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    {
      Name           = "primary-vpc"
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )

  lifecycle {
    # Confirm a valid CIDR range was provided.
    precondition {
      condition     = can(regex("^((10|010)\\.20[2-9]\\.([02468]|00[02468]|[0-9][02468]|0[0-9][02468]|1[0-9][02468]|2[0-4][02468]|25[024])\\.0/23)$", var.vpc_cidr))
      error_message = "The CIDR specified does not match one of the authorized CIDR ranges for a VPC in the organization."
    }
  }
}
