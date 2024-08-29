resource "aws_ssm_document" "s3_encryption_remediation" {
  name            = "S3EncryptionRemediationCMK"
  document_format = "YAML"
  document_type   = "Automation"

  content = data.template_file.s3_encryption_remediation_document.rendered

  tags = var.tags
}