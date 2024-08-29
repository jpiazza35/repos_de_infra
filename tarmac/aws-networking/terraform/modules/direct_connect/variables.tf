variable "tgw_id" {
  description = "ID of TGW to connect to."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_asn" {
  description = "Amazon side ASN for BGP peering."
  type        = number
}

variable "cx_asn" {
  description = "Customer side ASN for BGP peering."
  type        = number
}

variable "name" {
  description = "Base name for resources created."
  type        = string
}

variable "vlan" {
  description = "VLAN ID of the peering connection."
  type        = number
}

variable "dx_id" {
  description = "Direct Connect Connection ID"
  type        = string
}

variable "aws_address" {
  description = "The AWS side BGP Peer IP."
  type        = string
}

variable "cx_address" {
  description = "The customer side BGP Peer IP."
  type        = string
}

variable "mtu" {
  description = "The MTU size of the DX Connection."
  type        = number
  default     = 8500 # Jumbo Frames enabled
}

variable "prefixes" {
  description = "List of CIDR prefixes to advertise to the Direct Connect BGP Peer."
  type        = list(any)
}

variable "auth_key" {
  description = "The BGP Peering password for the Direct Connect."
  type        = string
}