module "msk" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//msk?ref=1.0.141"

  create        = true
  app           = "example-msk"
  env           = "dev"
  name          = "example-msk"
  kafka_version = "3.5.1"

  broker_node_connectivity_info = {
    public_access = {
      type = "SERVICE_PROVIDED_EIPS"
    }
  }

  broker_node_instance_type = "kafka.t3.small"

  client_authentication = {
    sasl = {
      iam = true
    }
  }

  additional_sg_rules = [
    {
      type        = "ingress"
      from_port   = 9092
      to_port     = 9092
      protocol    = "TCP"
      description = "Ingress from VPC to TCP:9092"
      cidr_blocks = [] ## Default is the vpc the cluster gets created in
    },
    {
      type        = "egress"
      from_port   = 9092
      to_port     = 9092
      protocol    = "TCP"
      description = "Egress from VPC to TCP:9092"
      cidr_blocks = [] ## Default is the vpc the cluster gets created in
    }
  ]

  create_configuration = true
  configuration_server_properties = {
    "auto.create.topics.enable" = true
    "delete.topic.enable"       = true
  }

}
