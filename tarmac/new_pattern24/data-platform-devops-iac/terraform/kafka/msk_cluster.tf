module "msk" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//msk?ref=1.0.142"

  create        = true
  app           = var.app
  env           = var.env
  name          = var.name
  kafka_version = var.kafka_version

  broker_node_connectivity_info = {
    public_access = {
      type = "DISABLED"
    }
  }

  broker_node_instance_type = var.kafka_instance_type

  client_authentication = {
    sasl = {
      iam = true
    }
  }

  jmx_exporter_enabled  = true
  node_exporter_enabled = true

  additional_sg_rules = [
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Ingress from CN All to VPC"
      cidr_blocks = ["10.0.0.0/8"] ## Default is the vpc the cluster gets created in
    }
  ]

  create_configuration = true
  configuration_server_properties = {
    "auto.create.topics.enable" = true
    "delete.topic.enable"       = true
  }

  tags = {
    Environment    = var.env
    App            = "msk"
    Resource       = "Managed by Terraform"
    Description    = "MSK Cluster Related Resources"
    SourcecodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    Team           = "Data Platform"
  }

}
