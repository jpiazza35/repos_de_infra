resource "aws_iam_user" "doc_vault" {
  count = var.create_example_machine_user ? 1 : 0
  name  = "DocumentVaultMachineUser"

  tags = var.tags
}
