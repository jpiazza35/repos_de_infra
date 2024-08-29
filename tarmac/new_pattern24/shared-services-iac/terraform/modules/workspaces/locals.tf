locals {
  defaults = {
    root_volume_encryption_enabled            = true
    user_volume_encryption_enabled            = true
    compute_type_name                         = "VALUE"
    compute_os_name                           = "Linux"
    user_volume_size_gib                      = 10
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

  subnets = flatten([
    for s in data.aws_subnet.private : flatten([
      for i in range(length(data.aws_subnets.private.ids) - 1) : s.availability_zone
    ])
  ])
}
