data "aws_route53_zone" "selected" {
  provider     = aws.ss_network
  name         = var.dns_name == "" ? local.dns_name : var.dns_name
  private_zone = false
}
