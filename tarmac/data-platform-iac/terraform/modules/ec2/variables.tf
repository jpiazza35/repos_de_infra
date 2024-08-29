variable "app" {
  type        = string
  description = "The name of the application"
}

variable "env" {
  type        = string
  description = "The name of the environment"
}

variable "vpc" {
  description = "The VPC to deploy into"
}

variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use"
}

variable "iam_instance_profile" {
  type        = string
  description = "The name of the IAM instance profile"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to use"
}

variable "volume_size" {
  description = "The size of the root volume in GB"
  default     = 20
}

variable "subnet_id" {
  description = "The subnet to deploy into"
}

variable "user_data" {
  description = "The user data to use"
}
