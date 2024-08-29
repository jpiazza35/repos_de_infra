variable "app" {
  default = "github-runner"
}

variable "env" {}

variable "instance_type" {
  default = "t3.medium"
}

variable "runner_name" {
  type        = string
  description = "The name of the runner."
}

variable "repository_url" {
  type        = string
  description = "The URL of the repository to link to the runner."
}

variable "github_token" {
  type        = string
  description = "The GitHub token to use for authenticating the runner."
}

variable "runner_labels" {
  type        = list(string)
  description = "The labels to assign to the runner."
  default     = []
}
