variable "tags" {
  type = map(string)
}

variable "repo_name" {
  description = "The CodeCommit repo name."
}

variable "sns_codecommit" {
  description = "The SNS Topic for CodeCommit events."
}