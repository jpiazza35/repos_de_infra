variable "project" {
  type = string
}
variable "cidr_block" {
  type = string
}
variable "public_subnets" {
  type = list(string)
  default = [
    "",
  ]
}
variable "private_subnets" {
  type = list(string)
  default = [
    "",
  ]
}
variable "availability_zones" {
  type = list(string)
  default = [
    "",
  ]
}
variable "nat" {
  description = "if set to false then don't create nat gateway"
  default     = true
}
variable "nat_eips" {
  description = "if set then use these instead of getting new eips"
  default     = [""]
  type        = list(string)
}
variable "region" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "private_dns" {
  type = string
}
variable "public_dns" {
  type = string
}