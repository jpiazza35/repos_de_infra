variable "properties" {
  type = object({
    function_name        = string
    description          = string
    handler              = string
    runtime_version      = string
    architectures        = string
    timeout              = number
    memory_size          = number
    ephemeral_storage    = number
    requirementsfilename = string
    codefilename         = string
    working_dir          = string
    variables            = map(string)
    inline_policies = optional(list(object({
      name = optional(string)
      policy = optional(object({
        Version = string
        Statement = list(object({
          Effect   = string
          Action   = list(string)
          Resource = list(string)
          })
        )
      }))
    })))
  })
}

variable "tags" {
  type        = map(any)
  description = "tags variable"
}
