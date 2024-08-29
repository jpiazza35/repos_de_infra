resource "aws_ssm_document" "doc" {
  for_each = {
    for file in fileset(path.module, "files/*.yml") : basename(file) => file
  }
  name            = "ebs-unnattached-${each.key}"
  document_format = "YAML"
  document_type   = "Command"

  content = file("${path.module}/files/${each.key}")
}
