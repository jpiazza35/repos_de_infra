locals {
  default = terraform.workspace == "sharedservices" ? 1 : 0
}
