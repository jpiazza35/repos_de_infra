variable "record_prefix" {
  description = "The name of the Route53 record to be created"
  type        = list(string)
}

variable "env" {
  description = "Environment the AWS Account this role is being configured in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "lb_dns_name" {
  description = "The DNS Name for the ALB"
  type        = string
}

variable "lb_dns_zone" {
  description = "Zone ID for the ALB"
  type        = string
}

variable "tags" {}

### ROUTE53
variable "hosted_zone_name" {
  description = "Name of the Hosted Zone to be created"
  default     = ""
}
variable "dns_name" {}
variable "create_local_zone" {
  description = "Should a Route53 Hosted Zone be created in the current AWS Account?"
  default     = false
}

variable "comment" {
  description = "Hosted Zone Comment/Description"
  default     = null
}
