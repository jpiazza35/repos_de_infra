variable "enabled" {
  default = false
}

variable "app" {
  default = ""
}

variable "env" {
  default = "shared_services"
}

variable "instance_type" {
  default = "t3.small"
}

variable "asg_min" {
  default = 1
}

variable "asg_max" {
  default = 2
}

variable "asg_desired" {
  default = 1
}

variable "vol_size" {
  default = 20
}

variable "tags" {
  default = {
    Environment = ""
    App         = ""
    Resource    = "Managed by Terraform"
    Description = ""
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

variable "arch" {
  default     = "amd64"
  type        = string
  description = "EC2 Architecture arm64/amd64 (amd64 is suggested)"
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

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP to the EC2 instance."
  default     = false
}


