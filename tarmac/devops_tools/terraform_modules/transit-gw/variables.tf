variable "vpc_id" {
  type        = string
  description = "The VPC ID."
}

variable "transit_gateway_id" {
  type        = string
  description = "The Id of the Networking Account Transit Gateway."
}

variable "private_subnets" {
  description = "This AWS account VPC private subnets."
  type        = list(string)
}

variable "create_transit_gw" {
  type        = string
  description = "Wether to create the Networking Account Transit Gw"
}

variable "create_transit_gw_vpc_attachment" {
  type        = string
  description = "Wether to create VPC attachments for Networking Account Transit Gw"
}

variable "create_transit_gw_routes" {
  type        = string
  description = "Wether to create routes to DataTrans on Prem in Transit Gw."
}

variable "example-account_organizations_arn" {
  description = "The Organization unit ARN"
  type        = list(string)
}

variable "s2s_vpn_attachment_dev" {
  type        = string
  description = "The s2s VPN attachment id for dev environment"
}

variable "static_route_cidr_dev" {
  type        = string
  description = "IP Cidr Static Route"
}

variable "tags" {
  type = map(string)
}