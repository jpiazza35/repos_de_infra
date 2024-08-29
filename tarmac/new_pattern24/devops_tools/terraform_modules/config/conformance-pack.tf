resource "aws_config_conformance_pack" "PCI_DSS" {
  count           = var.create_conformance_pack ? 1 : 0
  name            = "Operational-Best-Practices-for-PCI-DSS"
  template_s3_uri = "s3://${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-s3/Operational-Best-Practices-for-PCI-DSS.yml"
  depends_on      = [aws_s3_bucket_object.conformancePCIpack]
}