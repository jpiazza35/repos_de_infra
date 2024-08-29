resource "aws_config_config_rule" "s3_public_write_prohibit" {
  name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-s3-public-write-prohibit-rule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
}

resource "aws_config_config_rule" "s3_encryption_enabled" {
  name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-s3-encryption-enabled-rule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
}

resource "aws_config_config_rule" "s3_SSLonly_enabled" {
  name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-s3-SSLonly-enabled-rule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }
}

resource "aws_config_config_rule" "s3_bucket_policy_grantee_check" {
  name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-s3-bucket-policy-grantee-check-rule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_POLICY_GRANTEE_CHECK"
  }
}

resource "aws_config_config_rule" "iam_password_policy" {
  name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-iam-password-policy"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
}