variable "sso" {}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_parameters" {
  type = object({
    azs = list(string)
    networking = object({
      org_cidr_block       = string
      transit_vpc_cidr     = string
      secondary_cidr_block = string
    })
    max_subnet_count = number
    endpoints        = map(any)
  })
  default = {
    azs = []
    networking = {
      org_cidr_block       = ""
      transit_vpc_cidr     = ""
      secondary_cidr_block = ""
    }
    max_subnet_count = null
    endpoints        = {}
  }
}
