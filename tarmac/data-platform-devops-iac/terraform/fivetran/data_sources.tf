data "aws_caller_identity" "current" {}
data "aws_route53_zone" "selected" {
  provider = aws.ss_network
  name     = var.dns_name
}
