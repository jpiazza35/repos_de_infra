locals {
  default = terraform.workspace != "default" ? 1 : 0

  dns_name = var.env == "dev" ? "dev.cliniciannexus.com." : var.env == "qa" ? "qa.cliniciannexus.com." : var.env == "prod" ? "cliniciannexus.com." : var.env == "SS" ? "cliniciannexus.com." : "cliniciannexus.com."
}
