variable "cloudfront_default_root_object" {
  type = string
}

variable "cloudfront_error_code" {
  type = number
}

variable "cloudfront_response_code" {
  type = number
}

variable "cloudfront_response_page_path" {
  type = string
}

variable "cloudfront_origin_domain_name" {
  type = string
}

variable "cloudfront_origin_id" {
  type = string
}

variable "lb_dns" {
  type = string
}

variable "lb_zone_id" {
  type = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  type = string
}
variable "web_acl_arn" {
  type = string
}
variable "aws_acc_id_arn" {
  type = string
}
