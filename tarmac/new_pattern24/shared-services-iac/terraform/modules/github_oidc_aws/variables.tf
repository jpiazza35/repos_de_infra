variable "attach_admin_policy" {
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."
  type        = bool
}

variable "attach_read_only_policy" {
  description = "Flag to enable/disable the attachment of the ReadOnly policy."
  type        = bool
}

variable "create_oidc_provider" {
  description = "Flag to enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}

variable "enabled" {
  description = "Flag to enable/disable the creation of resources."
  type        = bool
}

variable "force_detach_policies" {
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = bool
}

variable "github_repositories" {
  description = "List of GitHub organization/repository names authorized to assume the role."
  type        = list(string)

  validation {
    // Ensures each element of github_repositories list matches the
    // organization/repository format used by GitHub.
    condition = length([
      for repo in var.github_repositories : 1
      if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+[*]?|\\*)$", repo)) > 0
    ]) == length(var.github_repositories)
    error_message = "Repositories must be specified in the organization/repository format."
  }
}

variable "iam_role_name" {
  description = "Name of the IAM role to be created. This will be assumable by GitHub."
  type        = string
}

variable "iam_role_path" {
  description = "Path under which to create IAM role."
  type        = string
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the permissions boundary to be used by the IAM role."
  type        = string
}

variable "iam_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "iam_role_inline_policies" {
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "tags" {
  description = "Map of tags to be applied to all resources."
  type        = map(string)

}
