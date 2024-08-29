variable "args" {
  type = map(object({
    cidr_block    = string
    subnet_groups = list(string)
  }))
}
