variable "tags" {
  type = map(string)
}

variable "allow_assume_role_productou_accounts" {
  description = "The assume role policy for the IAM role in the Shared Services AWS account."
}

variable "server_ecr_name" {
  description = "The server ECR repo name."
  type        = string
}

variable "server_ecr_name_prod" {
  description = "The server ECR repo name for prod environment."
  type        = string
}