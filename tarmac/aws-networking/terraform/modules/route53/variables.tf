variable "env" {
  type = string
}

variable "endpoint_subnets" {
  description = "Subnets for Route53 endpoints."
  type        = list(any)
}

variable "vpc_id" {
  description = "VPC ID where resources will reside."
  type        = string
}

variable "alternate_vpcs" {
  description = "VPC IDs where certain resources will reside."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "forwarding_zones" {
  description = "A map of DNS zones and forwarding IPs for the Route53 outbound endpoint."
  type        = map(any)
  default     = {}
}

variable "dns_zones_public" {
  description = "A list of maps with public DNS zone and record data."
  default     = []
}

variable "dns_zones_private" {
  description = "A list of maps with private DNS zone and record data."
  default     = []
}

variable "allow_overwrite" {
  description = "Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record."
  type        = bool
  default     = false
}

variable "enable_force_destroy" {
  description = "Whether to forcefully delete/overwrite existing DNS zones and records if they conflict with what is passed to this module."
  type        = bool
  default     = false
}

variable "org_arn" {
  description = "The ARN of the Organization to shared endpoints and zones with."
  type        = string
}

variable "health_check_disabled" {
  description = "Is the health check to be created enabled or disabled?"
  type        = bool
  default     = false
}

variable "health_check_port" {
  description = "The port of the endpoint to be checked."
  type        = number
  default     = 443
}

variable "health_check_type" {
  description = "The protocol to use when performing health checks. Valid values are HTTP, HTTPS, HTTP_STR_MATCH, HTTPS_STR_MATCH, TCP, CALCULATED, CLOUDWATCH_METRIC and RECOVERY_CONTROL."
  type        = string
  default     = "HTTPS"
}

variable "health_check_path" {
  description = "The path that you want Amazon Route 53 to request when performing health checks."
  type        = string
  default     = "/"
}

variable "health_check_search_string" {
  description = "String searched in the first 5120 bytes of the response body for check to be considered healthy. Only valid with HTTP_STR_MATCH and HTTPS_STR_MATCH."
  type        = string
  default     = null
}
variable "child_health_checks" {
  description = "For a specified parent health check, a list of HealthCheckId values for the associated child health checks."
  type        = list(string)
  default     = []
}

variable "cloudwatch_alarm_name" {
  description = "The name of the CloudWatch alarm to track in the health check"
  type        = string
  default     = null
}

variable "routing_control_arn" {
  description = "The Amazon Resource Name (ARN) for the Route 53 Application Recovery Controller routing control. This is used when health check type is RECOVERY_CONTROL"
  type        = string
  default     = null
}

variable "mac_cw_alarms" {
  description = "Cloudwatch Alarms for chi dc servers"
  default = [
    "chi-dc-mac-01",
    "chi-dc-mac-02"
  ]
}
