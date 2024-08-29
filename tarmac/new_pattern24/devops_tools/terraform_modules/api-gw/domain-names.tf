resource "aws_api_gateway_domain_name" "mtls" {
  count = var.mtls ? 1 : 0

  regional_certificate_arn = var.app_acm_public_certificate_arn
  domain_name              = "*.${var.tags["Application"]}.${var.env_public_dns_name}"
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  mutual_tls_authentication {
    truststore_uri = var.mtls ? var.truststore_pem_s3_uri : "s3://${aws_s3_bucket.api_gw_truststore[0].bucket}/truststore.pem"
  }

  tags = var.tags
}

resource "aws_api_gateway_domain_name" "no_mtls" {
  count = var.mtls ? 0 : 1

  regional_certificate_arn = var.app_acm_public_certificate_arn
  domain_name              = "*.${var.tags["Application"]}.${var.env_public_dns_name}"
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_domain_name" "ds" {
  count = var.create_ds_dns_resources ? length(var.ds_cards_records) : 0

  regional_certificate_arn = var.ds_acm_public_certificate_arn
  #regional_certificate_arn = var.ds_acm_public_certificates_arns[count.index]

  domain_name     = var.mtls ? "${var.ds_cards_records[count.index]}.${var.ds_public_dns_name}" : 0
  security_policy = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  mutual_tls_authentication {
    truststore_uri = "${var.truststore_s3_bucket_uri}/${var.ds_cards_records[count.index]}.pem"
  }

  tags = var.tags
}