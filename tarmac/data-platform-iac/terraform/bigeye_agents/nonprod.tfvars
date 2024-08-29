# todo: migrate state from d_data_platform. nonprod will not be compatible until this is done

env                           = "nonprod"
bigeye_mtls_secret_name       = "data_platform/dev/bigeye/certs"
agent_to_vault_secret_map     = {
  "i360" = "data_platform/dev/bigeye/i360"
}
