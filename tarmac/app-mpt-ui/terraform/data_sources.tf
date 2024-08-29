data "aws_lb" "alb" {
  name = var.alb_name
}

data "vault_generic_secret" "cloudfront_custom_header" {
  for_each = { for idx, val in var.s3_buckets : "${val.name}-${val.env}-${val.region}" => val }
  path     = each.value.env == "preview" ? "prod/${each.value.env}/${var.app}/cloudfront_custom_header" : "${each.value.env}/${var.app}/cloudfront_custom_header"
}