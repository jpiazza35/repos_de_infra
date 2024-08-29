agent_properties = {
  dataworld = {
    name = "dataworld",
    ecr = {
      image_tag_mutability = "MUTABLE",
      image_scanning = {
        scan_on_push = true
      }
      lifecycle_policy = {
        description            = "Retain only last 5 images"
        action_type            = "expire"
        selection_tag_status   = "any"
        selection_count_type   = "imageCountMoreThan"
        selection_count_number = 5
      }
    },
    ecs = {
      containerinsights_enable = "enabled",
      security_group_rules = {
        egress = [
          {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            self        = false
          }
        ],
        ingress = []
      },
      services = {
        dataworld_ces = {
          service                = "dataworld-ces"
          name                   = "dataworld-ces"
          cpu                    = 2048
          memory                 = 8192
          max_capacity           = 1
          min_capacity           = 0
          desired_count          = 0
          enable_execute_command = false
          taskDefinitionValues = {
            image_tag      = "latest"
            container_name = "dataworld-agent-ces"
            container_port = 8000
            host_port      = 8000
            awslogs-region = "us-east-1"
            awslogs-group  = "/ecs/p_data_platform-dataworld-ces"
            "essential" : true,
            # Container ports to expose
            portMappings = <<EOF
                     [
                         {
                             "hostPort": 8000,
                             "protocol": "tcp",
                             "containerPort": 8000
                         }
                     ]
                     EOF
          }
        }
      }
    }
  }
}
