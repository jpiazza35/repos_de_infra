data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_lb" "alb" {
  name = var.alb_name
}

## Get ACM Cert
data "aws_acm_certificate" "cert" {
  domain = local.domain_name
  statuses = [
    "ISSUED"
  ]
}

data "aws_route53_zone" "selected" {
  provider     = aws.ss_network
  name         = local.cf_r53_zone
  private_zone = false
}
