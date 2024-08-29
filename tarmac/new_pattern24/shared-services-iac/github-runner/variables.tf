variable "app" {
  description = "The application name"
  type        = string
}

variable "env" {
  description = "Environment (e.g., prod, dev, staging)"
  type        = string
}

variable "tags" {
  description = "Additional tags to attach to resources"
  type        = map(string)
  default     = {}
}

variable "ecr_image_tag" {
  description = "The ECR image tag"
  type        = string
  default     = "latest"
}
