data "aws_kms_key" "key" {
  key_id = "alias/aws/s3"
}