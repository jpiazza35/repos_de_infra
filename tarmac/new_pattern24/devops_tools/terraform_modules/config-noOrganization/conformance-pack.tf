resource "aws_config_conformance_pack" "cis-conf-pack" {
  count           = var.create_conformance_pack ? 1 : 0
  name            = "CIS-Conformance-Pack"
  template_s3_uri = "s3://${var.s3_bucket_conf}/Operational-Best-Practices-for-CIS.yaml"
  depends_on      = [aws_config_configuration_recorder.recorder]
}

