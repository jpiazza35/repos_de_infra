resource "aws_efs_file_system" "ecs_efs" {
  count          = var.create_da_cli_efs ? 1 : 0
  creation_token = "${var.tags["Environment"]}-${var.tags["Application"]}-efs"
  encrypted      = true

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Application"]}-efs"
    },
    var.tags,
  )
}

resource "aws_efs_mount_target" "ecs_efs_zone1" {
  count           = var.create_da_cli_efs ? 1 : 0
  file_system_id  = aws_efs_file_system.ecs_efs[0].id
  subnet_id       = element(tolist(var.private_subnets), 0)
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_efs_mount_target" "ecs_efs_zone2" {
  count           = var.create_da_cli_efs ? 1 : 0
  file_system_id  = aws_efs_file_system.ecs_efs[0].id
  subnet_id       = element(tolist(var.private_subnets), 1)
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_efs_mount_target" "ecs_efs_zone3" {
  count           = var.create_da_cli_efs ? 1 : 0
  file_system_id  = aws_efs_file_system.ecs_efs[0].id
  subnet_id       = element(tolist(var.private_subnets), 2)
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_efs_backup_policy" "ecs_efs" {
  count          = var.create_da_cli_efs ? 1 : 0
  file_system_id = aws_efs_file_system.ecs_efs[0].id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_access_point" "ecs_efs" {
  count          = var.create_da_cli_efs ? 1 : 0
  file_system_id = aws_efs_file_system.ecs_efs[0].id
  posix_user {
    gid = var.da_efs_posix_uid_gid
    uid = var.da_efs_posix_uid_gid
  }
  root_directory {
    creation_info {
      owner_gid   = var.da_efs_posix_uid_gid
      owner_uid   = var.da_efs_posix_uid_gid
      permissions = var.da_efs_posix_permission
    }
  }
}
