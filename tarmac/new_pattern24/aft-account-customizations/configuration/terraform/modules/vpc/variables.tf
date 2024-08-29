variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "The CIDR for the shared VPC."
  type        = string
}

variable "enable_public_subnets" {
  description = "Whether to add public subnets to the VPC."
  type        = bool
  default     = false
}

variable "aws_account_name" {
  description = "The name of the AWS account this project is associated with."
  type        = string
}

variable "attach_to_tgw" {
  description = "Whether to attach to the available TGW."
  type        = bool
  default     = false
}

variable "enable_secondary_cidr" {
  description = "Whether to add the secondary CIDR to the VPC (100.64.0.0/16)."
  type        = bool
  default     = false
}

variable "flowlog_bucket_arn" {
  description = "S3 Bucket ARN destination for VPC Flow Logs."
  type        = string
}

variable "vpc_parameters" {
  type = object({
    endpoints        = map(any)
    networking       = map(any)
    max_subnet_count = number
    azs              = list(string)
  })
}
