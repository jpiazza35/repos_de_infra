variable "public_ip" {
  type        = string
  description = "example-account On-Prem public IP"
}

variable "vpn_local_cidr" {
  type        = string
  description = "IPv4 VPN Local (on-prem side) Cidr"
}

variable "vpn_remote_cidr" {
  type        = string
  description = "IPv4 VPN Remote (aws side) Cidr"
}

variable "static_route_waf" {
  type        = string
  description = "IP Cidr Static Route"
}

variable "transit_gateway_id" {
  description = "Id of the Transit Gateway in Networking account"
  type        = string
}

variable "tags" {
  type = map(string)
}