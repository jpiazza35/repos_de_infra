locals {
  standard_tags = {
    Component   = "S3"
    Environment = var.env
    App         = var.app
    Resource    = var.tags["Resource"]
    Description = var.tags["Description"]
  }

  default = var.create_prereqs ? 1 : 0
}
