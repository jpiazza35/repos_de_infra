## Bucket policy to allow cloudfront
data "aws_iam_policy_document" "s3_bucket_policy_iam" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_bucket_distribution_oai.iam_arn]
    }
  }
}