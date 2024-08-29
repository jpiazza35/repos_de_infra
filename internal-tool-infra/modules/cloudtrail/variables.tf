variable "s3_bucket_acl" {
  description = "s3 bucket acl"
  type        = string
  default     = "private"
}

variable "tags" {
  description = "tags"
  type        = map(any)
}
