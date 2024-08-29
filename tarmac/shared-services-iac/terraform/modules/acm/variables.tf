variable "dns_name" {}
variable "tags" {
  default = {}
}
variable "san" {
  default = ["test", "now", "see"]
}
variable "dns_zone_id" {}
variable "create_wildcard" {
  description = "Should a wildcard cert be created?"
  default     = false
}
variable "env" {}
