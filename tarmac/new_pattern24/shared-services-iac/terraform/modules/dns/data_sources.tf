data "aws_route53_zone" "selected" {
  count        = local.default
  provider     = aws.ss_network
  name         = local.dns_name
  private_zone = false
}
