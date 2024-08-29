output "s3_config_conformance_pack_bucket_name" {
  description = "The name of the AWS Config Conformance Pack S3 bucket."
  value       = aws_s3_bucket.bucket_config.bucket
}

output "config_conformance_pack_arn" {
  description = "The ARN of the AWS Config Conformance Pack."
  value       = aws_config_conformance_pack.PCI_DSS.*.arn
}
