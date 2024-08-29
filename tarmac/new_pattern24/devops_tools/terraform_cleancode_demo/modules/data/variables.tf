variable "args" {
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
