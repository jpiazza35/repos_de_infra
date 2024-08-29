output "dashboard_vault_s3_bucket_name" {
  value = element(concat(aws_s3_bucket.dashboard_vault.*.bucket, tolist([""])), 0)
}