resource "aws_workspaces_directory" "directory" {

  directory_id = aws_directory_service_directory.ds.id
  ## https://docs.aws.amazon.com/workspaces/latest/adminguide/azs-workspaces.html
  subnet_ids = [
    for s in data.aws_subnet.private : s.id
    if(contains([s.availability_zone_id], "use1-az2") || contains([s.availability_zone_id], "use1-az4"))
  ]

  self_service_permissions {
    change_compute_type  = true
    increase_volume_size = true
    rebuild_workspace    = true
    restart_workspace    = true
    switch_running_mode  = true
  }

  workspace_access_properties {
    device_type_android    = "ALLOW"
    device_type_chromeos   = "ALLOW"
    device_type_ios        = "ALLOW"
    device_type_linux      = "ALLOW"
    device_type_osx        = "ALLOW"
    device_type_web        = "ALLOW"
    device_type_windows    = "ALLOW"
    device_type_zeroclient = "DENY"
  }

  workspace_creation_properties {
    # custom_security_group_id            = aws_security_group.workspaces.id
    # default_ou                          = "OU=AWS,DC=Workgroup,DC=sca,DC=local"
    enable_internet_access              = false
    enable_maintenance_mode             = true
    user_enabled_as_local_administrator = true
  }

  depends_on = [
    aws_iam_role.workspaces
  ]

}

resource "aws_workspaces_workspace" "workspaces" {
  for_each = { for k, v in var.workspaces :
    k => merge(local.defaults, v)
  }
  directory_id = aws_workspaces_directory.directory.id
  bundle_id    = each.value.compute_os_name == "Windows" ? data.aws_workspaces_bundle.standard_windows.id : data.aws_workspaces_bundle.standard_linux.id
  user_name    = each.value.user_name

  root_volume_encryption_enabled = each.value.root_volume_encryption_enabled
  user_volume_encryption_enabled = each.value.user_volume_encryption_enabled
  volume_encryption_key          = aws_kms_key.workspaces.arn

  workspace_properties {
    compute_type_name                         = each.value.compute_type_name
    user_volume_size_gib                      = each.value.user_volume_size_gib
    root_volume_size_gib                      = each.value.root_volume_size_gib
    running_mode                              = each.value.running_mode
    running_mode_auto_stop_timeout_in_minutes = each.value.running_mode_auto_stop_timeout_in_minutes
  }

  tags = merge(
    var.tags,
    {
      Name = each.value.user_name
    }
  )
}
