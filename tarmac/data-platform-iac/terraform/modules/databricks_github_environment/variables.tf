

variable "env" {
  type = string
  # validation: can be either sdlc or prod
  validation {
    condition     = var.env == "sdlc" || var.env == "prod"
    error_message = "env must be either sdlc or prod"
  }
}

variable "repository" {
  type = string
}

variable "databricks_aws_account_number" {
  type = string
}
