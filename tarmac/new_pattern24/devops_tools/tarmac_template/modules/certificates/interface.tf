variable "tags" {
  type = map(any)
}

variable "lb_dns" {
  type = string
}

variable "lb_zone_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_dns_zone_name" {
  type        = string
  description = "The name of the public Route53 DNS zone."
}

variable "public_dns_zone_id" {
  type        = string
  description = "The ID of the public Route53 DNS zone."
}

variable "cloudfront_domain_name" {
  type        = string
  description = "The Cloudfront domain name."
}