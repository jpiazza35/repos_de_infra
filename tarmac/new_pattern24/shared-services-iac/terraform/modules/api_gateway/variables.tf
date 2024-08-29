variable "app" {
  type        = string
  description = "Name of the application"
}

variable "github_repo_name" {
  type        = string
  description = "Name of the github repo"
}

variable "api_gateway_integration" {
  type = object({
    uri                  = string
    passthrough_behavior = string
    request_parameters = optional(map(object({
      "integration.request.header.Accept"        = string
      "integration.request.header.Authorization" = string
    })))
    request_templates = optional(map(object({
      key   = string
      value = string
    })))
  })
  description = "API Gateway Integration"
  default = {
    uri                  = ""
    passthrough_behavior = "WHEN_NO_TEMPLATES"
    request_parameters = {
      "integration.request.header.Accept"        = ""
      "integration.request.header.Authorization" = ""
    }
    request_templates = {
      "application/json" = <<EOF
{
"" : ""
}
EOF
    }
  }
}

