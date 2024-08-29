output "s3_code_pipeline_bucket_arn" {
  value = aws_s3_bucket.s3_code_pipeline.*.arn
}

output "s3_code_pipeline_bucket_name" {
  value = aws_s3_bucket.s3_code_pipeline.*.bucket
}

output "s3_pipeline_source_bucket_arn" {
  value = aws_s3_bucket.s3_pipeline_source.*.arn
}

output "s3_pipeline_source_bucket_name" {
  value = aws_s3_bucket.s3_pipeline_source.*.bucket
}

output "s3_cloud_trail_logs_bucket_arn" {
  value = aws_s3_bucket.s3_cloud_trail_logs.*.arn
}

output "s3_cloud_trail_logs_bucket_name" {
  value = aws_s3_bucket.s3_cloud_trail_logs.*.bucket
}

output "code_pipeline_role_arn" {
  value = aws_iam_role.code_pipeline_role.arn
}