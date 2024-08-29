variable "azure_app_roles" {
  default = [
    {
      display_name = "User"
      value        = ""
      description  = "User"
    },
    {
      display_name = "msiam_access"
      value        = ""
      description  = "msiam_access"
    }
  ]
}

variable "redirect_uris" {
  description = "The Reply URLs for the Enterprise App Single Sign On"
}

variable "homepage_url" {
  description = "The URL that a user can use to sign in to the application."
}

variable "id_token_issuance_enabled" {
  default = true
}

variable "access_token_issuance_enabled" {
  default = false
}

variable "app" {}
variable "env" {}

variable "custom_single_sign_on" {
  default = true
}

variable "enterprise" {
  default = true
}

variable "gallery" {}

variable "sign_in_audience" {}

variable "identifier_uris" {}

variable "prevent_duplicate_names" {
  default = true
}

variable "groups" {
  description = "Groups to be added to the Enterprise App for login access via SSO"
}

variable "preferred_single_sign_on_mode" {
  default = "saml"
}

variable "notification_email_addresses" {
  description = "Email addresses to send notifications regarding SSO SAML Cert expiration and Rotation."
  default = [
    "devops@cliniciannexus.com",
    "it@cliniciannexus.com"
  ]
}
