variable "workspace" {
  type        = string
  description = "Force the user into using a workspace, then return common profile information."
  validation {
    error_message = "Must be either dev, preview, sdlc or prod."
    condition     = var.workspace == "sdlc" || var.workspace == "prod" || var.workspace == "dev" || var.workspace == "preview"
  }
}
