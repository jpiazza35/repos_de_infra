variable "app" {
  default = "vault"
}

variable "env" {
  default = "shared_services"
}

variable "instance_type" {
  default = "t3.small"
}

variable "asg_min" {
  default = 2
}

variable "asg_max" {
  default = 3
}

variable "asg_desired" {
  default = 2
}

variable "vol_size" {
  default = 20
}

variable "tags" {
  default = {
    Environment = "shared_services"
    App         = "vault"
    Resource    = "Managed by Terraform"
    Description = "HCP Vault"
  }
}

/*  Cloudwatch */
variable "retention_in_days" {
  default = 30
}
variable "additional_permissions" {
  default = [
    "logs:CreateLogStream",
    "logs:DeleteLogStream",
  ]
}

variable "hvn_cidr" {
  default = "10.202.10.0/23"
}

variable "arch" {
  default     = "amd64"
  type        = string
  description = "EC2 Architecture arm64/amd64 (amd64 is suggested)"
}

variable "vault_version" {
  default     = "1.13.1"
  type        = string
  description = "Vault version to install"
}

variable "alb_arn" {}
variable "acm_arn" {}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "actions_alarm" {
  type        = list(string)
  default     = []
  description = "A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution."
}

variable "actions_ok" {
  type        = list(string)
  default     = []
  description = "A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution."
}

variable "alb_sg_id" {}
