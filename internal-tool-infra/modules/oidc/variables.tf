variable "oidc_environment" {
  description = "Environment where the OpenID Connect Provider will be created"
  type        = string
}

variable "oidc_provider_name" {
  description = "Name of the OpenID Connect Provider"
  type        = string
}

variable "oidc_provider_organization" {
  description = "OpenID Connect Provider Organization"
  type        = string
}

variable "oidc_provider_url" {
  description = "OpenID Connect Provider URL"
  type        = string
}

variable "oidc_provider_thumbprint_list" {
  description = "OpenID Connect Provider associated thumbprint list"
  type        = list(string)
}

variable "oidc_provider_extra_tags" {
  description = "Extra tags for the resources created through this module"
  type        = map(string)
}

variable "oidc_ecr_backend_name" {
  description = "ECR name where the backend image is published"
  type        = string
}