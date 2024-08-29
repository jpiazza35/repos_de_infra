locals {
  cloudtrail_name = "${var.tags["Name"]}-${var.tags["Environment"]}-cloudtrail"
}
