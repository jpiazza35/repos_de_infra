locals {
  script = templatefile("${path.module}/init.sh.tftpl",
    {
      NEXUS_USER     = var.nexus_user
      NEXUS_PASSWORD = var.nexus_password
      NEXUS_URL      = var.nexus_url
      NEXUS_BASE_URL = var.nexus_base_url
      BSR_USER       = var.bsr_user
      BSR_PASSWORD   = var.bsr_password
      BSR_URL        = var.bsr_url
    }
  )
  script_name = "pip_configuration.sh"
}

# todo: make provisioning on a shared cluster/ databricks volume easier
resource "databricks_global_init_script" "init" {
  count          = var.create_global_script ? 1 : 0
  content_base64 = base64encode(local.script)
  name           = local.script_name
  enabled        = true
}
