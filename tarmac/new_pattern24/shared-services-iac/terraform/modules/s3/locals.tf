locals {
  tags = {
    Environment = var.bucket_properties.env
  }

  s3_website_domain = var.bucket_properties.env == "prod" ? format("%s", var.bucket_properties.s3_website_domain) : format("%s.%s", var.bucket_properties.env, var.bucket_properties.s3_website_domain)
}
