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

variable "aws_region" {
  type = string
}

variable "app" {
  type = string
}

variable "alb_name" {
  type    = string
  default = "mpt-ingress"
}

variable "tags" {
  default = {
    Environment    = ""
    App            = "MPT UI"
    Resource       = "Managed by Terraform"
    Description    = "MPT UI Static S3 Site Resources"
    SourceCodeRepo = "https://github.com/clinician-nexus/app-mpt-ui"
    Team           = "DevOps"
  }
}

variable "vault_url" {
  description = "Vault target URL"
  type        = string
  default     = "https://vault.cliniciannexus.com:8200"
}