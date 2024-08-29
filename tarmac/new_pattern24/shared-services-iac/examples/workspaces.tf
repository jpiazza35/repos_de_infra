module "workspaces" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules/workspaces?ref=1.0.183"

  app = "workspaces"

  dc_ips = [
    ## using ssdc01 and ssdc02 in us-east-1 for testing
    "10.202.4.68",
    "10.202.4.198"
  ]

  env = "prod"

  workspaces = {
    panong = {
      user_name                                 = "panong"
      compute_type_name                         = "VALUE"
      compute_os_name                           = "Linux"
      user_volume_size_gib                      = 10
      root_volume_size_gib                      = 80
      running_mode                              = "AUTO_STOP"
      running_mode_auto_stop_timeout_in_minutes = 60
    }
    jdoe = {
      user_name                                 = "jdoe"
      compute_type_name                         = "STANDARD"
      compute_os_name                           = "Windows"
      user_volume_size_gib                      = 50
      root_volume_size_gib                      = 80
      running_mode                              = "AUTO_STOP"
      running_mode_auto_stop_timeout_in_minutes = 120
    }
  }

  tags = {
    Team           = "DevOps"
    Managedby      = "Terraform"
    SourceCodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }

}
