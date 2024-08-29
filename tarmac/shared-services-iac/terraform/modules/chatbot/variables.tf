variable "env" {
  type = string
}

variable "app" {
  type = string
}

variable "guardrail_policies" {
  type = list(string)
}

variable "log_level" {
  type = string
}

variable "slack_channel_id" {
  type = list(string)
}

variable "slack_workspace_id" {
  type = string
}

variable "list_email_address" {
  type = list(string)
}
