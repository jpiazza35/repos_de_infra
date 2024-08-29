resource "aws_iam_policy" "doc_vault" {
  count       = var.create_example_machine_user ? 1 : 0
  name        = "${element(concat(aws_iam_user.doc_vault.*.name, tolist([""])), 0)}-s3-policy"
  description = "This policy allows the Document Vault machine user to access S3."
  path        = "/"
  policy      = data.template_file.doc_vault.rendered

  tags = var.tags
}
