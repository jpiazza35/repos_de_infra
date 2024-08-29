variable "app" {
  default = "trustgrid"
}

variable "env" {
  default = "dev"
}

variable "instance_type" {
  default = "t3.medium"
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
  default = 30
}

variable "tags" {
  default = {
    Environment = "dev"
    App         = "trustgrid"
    Resource    = "Managed by Terraform"
    Description = "Data.World Trustgrid"
  }
}

/*  Cloudwatch */
variable "retention_in_days" {
  default = 30
}

variable "eni" {
  description = "ENIs to be attached"
  default = {
    management = 0
    data       = 1
  }
}

variable "additional_sg_rules" {
  description = "Additional SG rules to be added to Trustgrid SG"
}
