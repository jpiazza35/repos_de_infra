variable "region" {
  default     = "us-east-1"
  description = "The region to create resources in."
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name."
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
}

## Bucket ACL related variables
variable "create_bucket_acl" {
  description = "A boolean that determines whether to add ACL to the S3 bucket."
  type        = bool
}

variable "bucket_acl" {
  description = "The S3 bucket ACL."
  type        = string
}

## Bucket encryption related variables
variable "create_bucket_encryption" {
  description = "A boolean that determines whether to encrypt the S3 bucket."
  type        = bool
}

variable "use_cmk_kms_key" {
  description = "Whether to use a Customer Managed KMS key for encrypting the S3 bucket. When false, the AWS aws/s3 managed KMS key is used."
  type        = bool
  default     = false
}

variable "cmk_kms_key_arn" {
  description = "If Customer Managed KMS key is used for S3, this is key's ARN."
  type        = string
  default     = ""
}

## Bucket block public access related variables
variable "create_bucket_block_public_access" {
  description = "A boolean that determines whether to create the S3 bucket block public access resource."
  type        = bool
}

variable "block_public_acls" {
  description = "A boolean that indicates whether S3 public ACLs are blocked."
  type        = bool
}

variable "block_public_policy" {
  description = "A boolean that indicates whether S3 public policies are blocked."
  type        = bool
}

variable "ignore_public_acls" {
  description = "A boolean that indicates whether S3 public ACLs are blocked."
  type        = bool
}

variable "restrict_public_buckets" {
  description = "A boolean that indicates whether S3 public policies are restricted."
  type        = bool
}

## Bucket policy related variables
variable "create_bucket_policy" {
  description = "A boolean that determines whether to create an S3 bucket policy."
  type        = bool
}

variable "bucket_policy_document" {
  description = "The S3 bucket policy declared as aws_iam_policy_document data source."
}

## Bucket versioning related variables
variable "create_bucket_versioning" {
  description = "A boolean that determines whether to enable S3 bucket versioning."
  type        = bool
}

variable "versioning_status" {
  description = "The versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled."
  type        = string
}

## Bucket website configuration related variables
variable "create_bucket_website" {
  description = "A boolean that determines whether to create the S3 website configuration for a bucket."
  type        = bool
}

variable "index_document_file" {
  description = "The name of the file that will be used in the index_document block under aws_s3_bucket_website_configuration."
  type        = string
}

variable "error_document_file" {
  description = "The name of the file that will be used in the error_document block under aws_s3_bucket_website_configuration."
  type        = string
}

## Bucket lifecycle configuration related variables
variable "create_bucket_lifecycle" {
  description = "A boolean that determines whether to create lifecycle configuration for the S3 bucket."
  type        = bool
}

variable "bucket_lifecycle_id" {
  description = "The ID of the S3 lifecycle configuration."
  type        = string
}

variable "bucket_lifecycle_status" {
  description = "Whether the lifecycle rule is currently being applied. Valid values: Enabled or Disabled."
  type        = string
}

variable "bucket_lifecycle_expiration_days" {
  description = "The lifetime of an object before it is subjected to the rule. In days."
  type        = number
}

variable "bucket_lifecycle_noncurrent_expiration_days" {
  description = "The number of days an object is noncurrent before Amazon S3 can perform the associated action."
  type        = number
}

variable "bucket_lifecycle_incomplete_multipart_days" {
  description = "The number of days after which Amazon S3 aborts an incomplete multipart upload."
  type        = number
}
