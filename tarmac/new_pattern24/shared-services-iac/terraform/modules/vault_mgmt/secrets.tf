resource "vault_kv_secret" "codespaces" {
  count = local.count
  path  = "${vault_mount.kv["dev"].path}/codespaces"
  data_json = jsonencode(
    {
      create = "yes"
    }
  )
}
