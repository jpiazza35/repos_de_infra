variable "tags" {
  type        = map(any)
  description = "tags to attach to the lambda module's resources"
}

variable "env" {
  type        = string
  description = "The environment to deploy the lambda module to"
}

variable "lambda" {
  description = "Lambda properties"
}

variable "sns_email" {
  description = "The email address to send SNS notifications to"
  type        = string
}
