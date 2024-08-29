variable "enabled" {
  description = "Flag to enable/disable the creation of resources."
  type        = bool
}

variable "enable_low_cpu_metric_alarm" {
  description = "Flag to enable/disable the creation of low CPU metric alarm."
  type        = bool
  default     = false
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

variable "vol_type" {
  default = "gp3"
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


variable "vpc_id" {
  description = "The VPC ID."
  type        = string
  default     = ""
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

variable "recovery_window" {
  description = "Number of days for Secrets Manager secret recovery window."
  default     = 14
}

variable "additional_volumes" {
  description = "Volumes to be created with the instance"
  default = [
    /* {
      "device_name"           = "/dev/xvdf"
      "delete_on_termination" = true
      "encrypted"             = true
      "volume_size"           = var.vol_size
      "volume_type"           = var.vol_type
    } */
  ]
}

variable "ami_to_find" {
  description = "AMI name to be used in data_source search. If left blank, ubuntu 20.04 will be used"
  default = {
    name  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    owner = "099720109477"
  }
}

variable "user_data" {
  description = "Script to be run on initialization of the instance"
  default     = null
  type        = string
}

variable "additional_iam_policy_arn" {
  description = "The ARN of an additional IAM policy to be attached to the instance role"
  default     = null
  type        = string
}

variable "additional_sg_rules" {
  description = "Additional security group rules to be added to the instance"
  default = [
    /* {
      type        = "ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Ingress from VPC to all ports and protocols."
      cidr_blocks = [
        data.aws_vpc.vpc[0].cidr_block
      ]
    } */
  ]
}

variable "instance_profile_arn" {
  description = "The ARN of an instance profile to be attached to the instance"
  default     = ""
  type        = string
}

variable "protect_from_scale_in" {
  description = "Protect the instance from scale in"
  type        = bool
  default     = false
}
