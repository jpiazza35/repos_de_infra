variable "tags" {
  description = "EC2 tags"
  type        = map(any)
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
  type        = string
}

variable "public_subnets" {
  description = "public_subnets"
  type        = list(any)
}

variable "key_pair" {
  description = "key_pair"
  type        = string
}

variable "instance_ami" {
  description = "instance_ami"
  type        = string
}

variable "instance_type" {
  description = "instance_type"
  type        = string
}

variable "tarmac_mkd_office_static_ip" {
  description = "tarmac_mkd_office_static_ip"
  type        = string
}


