data "aws_acm_certificate" "staplerroja" {
  provider = aws.dev_account
  count    = var.environment == "prod" ? 1 : 0
  domain   = "*.staplerroja.com"
}
