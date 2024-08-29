variable "workspace" {
  type        = string
  description = "Force the user into using a workspace, then return common profile information."
  validation {
    error_message = "Must be either sdlc or prod."
    condition     = var.workspace == "sdlc" || var.workspace == "prod"
  }
}
