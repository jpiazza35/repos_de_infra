variable "s3_bucket_conf" {
  type        = string
  description = "S3 bucket used to upload conformance pack"
}

variable "create_conformance_pack" {
  default     = true
  type        = bool
  description = "Variable to enable or disable creation of conformance pack"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resource"
}
