
# ### EFS INCIDENT BOT
# resource "aws_efs_file_system" "ecs_efs_incident_bot" {
#   encrypted        = true
#   performance_mode = "maxIO"
#   throughput_mode  = "bursting"

#   tags = {
#     Name           = "Incident-Bot-DB-Storage"
#     SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
#   }
# }

# resource "aws_efs_access_point" "incident_bot_ap" {
#   file_system_id = aws_efs_file_system.ecs_efs_incident_bot.id

#   root_directory {
#     path = "/incidentbot/data"

#   }

#   tags = merge(
#     var.tags,
#     {
#       Name           = "incident_bot_ap"
#       SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
#     }
#   )
# }

# resource "aws_efs_mount_target" "efs_ecs_incident_bot_mount_0" {
#   file_system_id  = aws_efs_file_system.ecs_efs_incident_bot.id
#   subnet_id       = local.selected_subnet_id_0
#   security_groups = [aws_security_group.ecs_efs_incident_bot[0].id]
# }

# resource "aws_efs_mount_target" "efs_ecs_incident_bot_mount_1" {
#   file_system_id  = aws_efs_file_system.ecs_efs_incident_bot.id
#   subnet_id       = local.selected_subnet_id_1
#   security_groups = [aws_security_group.ecs_efs_incident_bot[0].id]
# }

# resource "aws_efs_mount_target" "efs_ecs_incident_bot_mount_2" {
#   file_system_id  = aws_efs_file_system.ecs_efs_incident_bot.id
#   subnet_id       = local.selected_subnet_id_2
#   security_groups = [aws_security_group.ecs_efs_incident_bot[0].id]
# }


# ## SG for INCIDENT BOT EFS

# resource "aws_security_group" "ecs_efs_incident_bot" {
#   count       = local.default
#   vpc_id      = data.aws_vpc.vpc[0].id
#   name        = "ecs_efs_incident_bot_sg"
#   description = "Fargate service security group for EFS"

#   ingress {
#     description = "ALL from VPC"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [
#       data.aws_vpc.vpc[0].cidr_block
#     ]
#   }

#   ingress {
#     description = "Allow all for EFS"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = merge(
#     var.tags,
#     {
#       Name           = "ecs_efs_incident_bot_sg"
#       SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
#     },
#   )

#   revoke_rules_on_delete = true

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# ## INCIDENT BOT
# module "incident_bot_dns" {
#   source = "./modules/dns"
#   providers = {
#     aws            = aws
#     aws.ss_network = aws.ss_network
#   }
#   env               = var.env
#   vpc_id            = data.aws_vpc.vpc[0].id
#   lb_dns_name       = module.ecs.incident_bot_lb_dns_name
#   lb_dns_zone       = module.ecs.incident_bot_lb_dns_zone
#   dns_name          = "cliniciannexus.com"
#   create_local_zone = false
#   record_prefix = [
#     "incident-bot"
#   ]
#   tags = merge(
#     var.tags,
#     {
#       Environment    = var.env
#       App            = "ecs"
#       Resource       = "Managed by Terraform"
#       Description    = "DNS Related Configuration"
#       Team           = "DevOps"
#       SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
#     }
#   )
# }

# module "ecr_incident_bot" {
#   source = "./modules/ecr"
#   app    = "incident-bot"
#   env    = var.env
#   tags   = var.tags
# }
