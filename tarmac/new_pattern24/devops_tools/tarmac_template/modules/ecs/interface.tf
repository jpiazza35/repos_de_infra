#ECS Cluster
variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "public subnet for ECS"
}

variable "public_subnets" {
  description = "public subnet for ECS"
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block."
  type        = string
}

variable "config_services" {
  description = "All the services in the map object"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "internal_dns_zone_name" {
  description = "Internal R53 DNS zone name"
  type        = string
}

variable "internal_dns_id" {
  description = "Internal R53 DNS zone ID"
  type        = string
}

variable "public_dns_zone_name" {
  description = "The public R53 DNS zone name"
  type        = string
}

variable "alb_priority" {
  description = "Internal ALB listener rule priority."
  type        = number
}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the public ACM certificate used in the ALB listener."
}

##ECS autoscaling variables

variable "max_capacity" {
  default     = 4
  type        = number
  description = "Max capacity for autoscaling ECS target"
}

variable "min_capacity" {
  default     = 1
  type        = number
  description = "Min capacity for autoscaling ECS target"
}

variable "enable_asg" {
  default = true
  type    = bool
}

variable "exec_command" {
  default     = false
  type        = bool
  description = "Variable to turn on or off access to Fargate tasks"
}
