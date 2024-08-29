variable "lambda_environment" {
  description = "Environment where the notification mechanism will be deployed"
  type        = string
}

variable "lambda_project" {
  description = "Project where the notification mechanism is attached"
  type        = string
}

variable "lambda_request_memory_size" {
  description = "Memory size for the notification lambda"
  type        = number
  default     = 512
}
