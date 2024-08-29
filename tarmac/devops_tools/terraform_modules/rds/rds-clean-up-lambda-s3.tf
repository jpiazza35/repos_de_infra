resource "aws_s3_bucket_object" "rds_clean_up_source" {
  count  = var.create_ci_cd_lambdas ? 1 : 0
  bucket = var.ci_cd_lambdas_source_code_s3_bucket
  key    = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-clean-up.jar"
  source = "${path.module}/rds-clean-up-lambda-source/rds-clean-up.jar"
}
