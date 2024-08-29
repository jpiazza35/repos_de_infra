variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "The CIDR for the VPC."
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

variable "name" {
  description = "Name to give the new VPC."
  type        = string
}

variable "org_tgw_id" {
  description = "ID of TGW to attach to."
  type        = string
}

variable "enable_secondary_cidr" {
  description = "Whether to add the secondary CIDR to the VPC (100.64.0.0/16)."
  type        = bool
  default     = false
}

variable "enable_nat_gateways" {
  description = "Whether to add NAT gateways to public subnets. Requires enable_public_subnets == true."
  type        = bool
  default     = false
}

variable "enable_default_rtb_association" {
  description = "Whether to associate the attachment with the TGW default route table."
  type        = bool
  default     = true
}

variable "enable_default_rtb_propagation" {
  description = "Whether to propagate the attachment to the TGW default route table."
  type        = bool
  default     = true
}

variable "endpoints" {
  type = map(any)
}
