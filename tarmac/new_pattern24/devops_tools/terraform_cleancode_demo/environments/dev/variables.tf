variable "global_args" {
  type = object({
    profile            = string
    region             = string
    availability_zones = list(string)
    project            = string
    product            = string
    env                = string
  })
}

variable "vpc_args" {
  type = map(object({
    cidr_block    = string
    subnet_groups = list(string)
  }))
}

variable "dynamodb_args" {
  type = map(object({
    hash_key       = string
    hash_key_type  = string
    range_key      = string
    range_key_type = string
    read_capacity  = number
    write_capacity = number
    billing_mode   = string
    attribute_definitions = list(object({
      name = string
      type = string
    }))
    global_secondary_indexes = list(object({
      name            = string
      hash_key        = string
      hash_key_type   = string
      range_key       = string
      range_key_type  = string
      projection_type = string
      read_capacity   = number
      write_capacity  = number
    }))
  }))
}
