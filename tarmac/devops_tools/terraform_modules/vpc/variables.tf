variable "profile" {
  description = "The AWS cli profile for the account where the terraform code is run."
}

variable "create_vpc_s3_endpoint" {
  type        = bool
  description = "Boolean, whether to create the VPC endpoint."
}

variable "create_vpc_secrets_endpoint" {
  type        = bool
  description = "Boolean, whether to create the VPC endpoint."
}

variable "create_sqs_vpc_endpoint" {
  type        = bool
  default     = false
  description = "Boolean, whether to create the SQS VPC endpoint."
}

variable "create_example-account_on_prem_routes" {
  type        = bool
  description = "Whether to create routes to example-account on-prem."
}

variable "create_open_search_routes" {
  type        = bool
  description = "Whether to create routes for OpenSearch cluster."
}

variable "cidr_block" {
  description = "The AWS VPC CIDR block."
  type        = string
}

variable "netmask_length" {
  description = "Netmask Length for the VPC"
  type        = number
}

variable "private_subnets" {
  description = "The AWS account VPC private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "The AWS account VPC public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "The AWS availability zones in the region."
  type        = list(string)
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "transit_gateway_id" {
  type        = string
  description = "The Id of the Networking Account Transit Gateway."
}

variable "example-account_on_prem1" {
  description = "The example-account on-prem CIDR block."
  type        = string
}

variable "example-account_on_prem2" {
  description = "The example-account on-prem CIDR block."
  type        = string
}

variable "open_search_cidr" {
  description = "The CIDR block for OpenSearch cluster routes."
  type        = list(string)
}

variable "tags" {
  type = map(string)
}