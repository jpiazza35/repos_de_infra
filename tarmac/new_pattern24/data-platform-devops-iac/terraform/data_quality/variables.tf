variable "s3_buckets" {
  type = map(object({
    name                           = string
    env                            = string
    region                         = string
    enable_acl                     = optional(bool)
    acl                            = optional(string)
    enable_website_configuration   = bool
    s3_website_dns_record          = optional(string)
    s3_website_domain              = optional(string)
    index_document_file            = string
    error_document_file            = string
    enable_versioning              = bool
    versioning_configuration       = string
    enable_lifecycle_configuration = bool
    lifecycle_id                   = string
    lifecycle_status               = string
    expiration = optional(object({
      enabled = optional(bool)
      days    = number
    }))
    lifecycle_noncurrent_expiration_days = number
    lifecycle_incomplete_multipart_days  = number
    sse_algorithm                        = optional(string)
    kms_key_arn                          = optional(string)
  }))
}

variable "tags" {
  default = {
    Environment    = ""
    App            = "Great Expectations"
    Resource       = "Managed by Terraform"
    Description    = "Great Expectations Static S3 Site Resources"
    SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    Team           = "DevOps"
  }
}

variable "aws_region" {}
variable "app" {}
variable "dns_name" {}
variable "env" {}