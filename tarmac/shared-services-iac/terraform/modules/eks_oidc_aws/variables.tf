variable "region" {
  description = "Region where AWS resources will be created in."
  type        = string
}

variable "create_oidc_provider" {
  description = "Flag to enable/disable the creation of the EKS OIDC provider."
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

variable "eks_provider_urls" {
  description = "List of EKS OIDC URLs authorized to assume the role."
  type        = list(string)
}

variable "iam_role_name" {
  description = "Name of the IAM role to be created. This will be assumable by EKS."
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
