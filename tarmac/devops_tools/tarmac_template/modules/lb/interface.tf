variable "load_balancer_name" {
  description = "Load balancer name"
  type        = string
  default     = "application-load-balancer"
}
variable "load_balancer_internal" {
  description = "Internal load balancer"
  type        = bool
  default     = false
}
variable "load_balancer_type" {
  description = "Load balancer type"
  type        = string
  default     = "application"
}
variable "load_balancer_deletion_protection" {
  description = "Load balancer deletion protection"
  type        = bool
  default     = false
}
variable "load_balancer_log_prefix" {
  description = "Load balancer log prefix"
  type        = string
  default     = "lb-log"
}
variable "load_balancer_log_enabled" {
  description = "Load balancer log enable"
  type        = bool
  default     = true
}

variable "load_balancer_log_bucket" {
  description = "Load balancer log bucket"
  type        = string
  default     = ""
}

variable "load_balancer_security_group_id" {
  description = "Load balancer security group id"
  type        = string
  default     = ""
}

variable "load_balancer_subnets" {
  description = "Load balancer subnets"
  type        = list(string)
  default     = [""]
}

variable "tags" {
  type = map(any)
}

# variable "instance" {
#   description = "Instance"
# }

variable "vpc_id" {
  description = "vpc id"
}