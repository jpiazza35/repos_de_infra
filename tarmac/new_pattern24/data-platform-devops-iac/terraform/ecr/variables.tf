variable "app" {
  description = "The name of the app for the ECR repository"
  type        = string
}

variable "env" {
  description = "The environment (dev/prod/etc)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)

}
