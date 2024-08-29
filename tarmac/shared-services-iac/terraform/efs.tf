

### EFS Sonatype

resource "aws_efs_file_system" "ecs_efs_sonatype" {
  encrypted        = true
  performance_mode = "maxIO"
  throughput_mode  = "bursting"

  tags = {
    Name           = "ECS-EFS-FS-Sonatype"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

resource "aws_efs_access_point" "sonatype_ap" {
  file_system_id = aws_efs_file_system.ecs_efs_sonatype.id
  posix_user {
    gid = 200 #  Sonatype Nexus artifactory user
    uid = 200
  }
  root_directory {
    path = "/sonatype/data"
    creation_info {
      owner_gid   = 200
      owner_uid   = 200
      permissions = 755
    }
  }
}

resource "aws_efs_mount_target" "efs_ecs_2_mount_0" {
  file_system_id  = aws_efs_file_system.ecs_efs_sonatype.id
  subnet_id       = local.selected_subnet_id_0
  security_groups = [aws_security_group.ecs_efs_2_sg[0].id]
}

resource "aws_efs_mount_target" "efs_ecs_2_mount_1" {
  file_system_id  = aws_efs_file_system.ecs_efs_sonatype.id
  subnet_id       = local.selected_subnet_id_1
  security_groups = [aws_security_group.ecs_efs_2_sg[0].id]
}

resource "aws_efs_mount_target" "efs_ecs_2_mount_2" {
  file_system_id  = aws_efs_file_system.ecs_efs_sonatype.id
  subnet_id       = local.selected_subnet_id_2
  security_groups = [aws_security_group.ecs_efs_2_sg[0].id]
}


### EFS INCIDENT BOT
resource "aws_efs_file_system" "ecs_efs_incident_bot" {
  encrypted        = true
  performance_mode = "maxIO"
  throughput_mode  = "bursting"

  tags = {
    Name           = "Incident-Bot-DB-Storage"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

resource "aws_efs_access_point" "incident_bot_ap" {
  file_system_id = aws_efs_file_system.ecs_efs_incident_bot.id

  root_directory {
    path = "/incidentbot/data"

  }

  tags = merge(
    var.tags,
    {
      Name           = "incident_bot_ap"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_efs_mount_target" "efs_ecs_incident_bot_mount_0" {
  file_system_id  = aws_efs_file_system.ecs_efs_incident_bot.id
  subnet_id       = local.selected_subnet_id_0
  security_groups = [aws_security_group.ecs_efs_incident_bot[0].id]
}

resource "aws_efs_mount_target" "efs_ecs_incident_bot_mount_1" {
  file_system_id  = aws_efs_file_system.ecs_efs_incident_bot.id
  subnet_id       = local.selected_subnet_id_1
  security_groups = [aws_security_group.ecs_efs_incident_bot[0].id]
}

resource "aws_efs_mount_target" "efs_ecs_incident_bot_mount_2" {
  file_system_id  = aws_efs_file_system.ecs_efs_incident_bot.id
  subnet_id       = local.selected_subnet_id_2
  security_groups = [aws_security_group.ecs_efs_incident_bot[0].id]
}
