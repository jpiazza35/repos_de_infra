locals {
  prefix          = format("%s-%s", var.env, var.app)
  identifier_uris = var.identifier_uris != [] ? join(",", var.identifier_uris) : ""

}

