variable "org_arn" {
  description = "The AWS Organizations organization ARN."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN."
  type        = string
  default     = null
}

variable "aws_account_name" {
  description = "The name of the AWS account this project is associated with."
  type        = string
}

variable "dx_aws_asn" {
  description = "Amazon side ASN for BGP peering over direct connect."
  type        = number
}

variable "dx_cx_asn" {
  description = "Customer side ASN for BGP peering over direct connect."
  type        = number
}

variable "dx_vlan" {
  description = "VLAN ID of the peering connection over direct connect."
  type        = number
}

variable "dx_id" {
  description = "The ID of the Direct Connect connection."
  type        = string
}

variable "dx_aws_address" {
  description = "The AWS side BGP Peer IP."
  type        = string
}

variable "dx_cx_address" {
  description = "The customer side BGP Peer IP."
  type        = string
}

variable "dx_prefixes" {
  description = "List of CIDR prefixes to advertise to the Direct Connect BGP Peer."
  type        = map(any)
}

variable "dx_auth_key" {
  description = "The BGP Peering password for the Direct Connect."
  type        = string
}

variable "route53_forwarding_zones" {
  description = "A map of DNS zones and forwarding IPs for the Route53 outbound endpoint."
  type        = map(any)
  default     = {}
}

variable "endpoints" {
  description = "values for the vpc endpoints to create"
  type        = map(any)
}
