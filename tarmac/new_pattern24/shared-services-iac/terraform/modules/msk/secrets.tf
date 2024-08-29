resource "aws_msk_scram_secret_association" "secret" {
  count = var.create && var.create_scram_secret_association && try(var.client_authentication.sasl.scram, false) ? 1 : 0

  cluster_arn     = aws_msk_cluster.msk[0].arn
  secret_arn_list = var.scram_secret_association_secret_arn_list
}
