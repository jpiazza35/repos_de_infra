resource "vault_generic_secret" "rds_credentials" {
  path = var.vault_secret.path

  data_json = <<EOT
{
  "host_rw": "${aws_rds_cluster.db_cluster.endpoint}",
  "host_ro": "${aws_rds_cluster.db_cluster.reader_endpoint}",
  "username": "${var.cluster.cluster_master_username}",
  "password": "${local.password}",
  "port": "${aws_rds_cluster.db_cluster.port}"
}
EOT
}
