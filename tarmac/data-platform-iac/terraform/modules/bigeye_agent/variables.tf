variable "env" {}

variable "vpc_name" {
  type    = string
  default = "primary-vpc"
}

variable "mtls_secret_name" {
  type        = string
  description = "Path to HC Vault secret where all the mtls secrets are stored"
}

variable "agent_config_secret_name" {
  type        = string
  description = "Path to HC Vault secret where the agent.yaml parameters are stored"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the EC2 instance"
  default     = "us-east-1"
}

variable "ami_to_find" {
  description = "AMI name to be used in data_source search. If left blank, Amazon Linux 2 will be used"
  default = {
    name  = "amzn2-ami-hvm-2.0.20230727.0-x86_64-ebs"
    owner = "137112412989"
  }
}

variable "iam_instance_profile" {
  type        = string
  default     = "vault_aws_auth"
  description = "The name of the IAM instance profile to be attached to the EC2 instance"
}

variable "agent_to_vault_secret_map" {
  type = map(string)
  description = "A mapping of agent identifier to Vault secret path. This will be used to identify the agents in the Bigeye UI."
}

variable "agent_type" {
  type        = string
  description = "The type of the agent. Allowed_values are awsathena, mysql, oracle, postgresql, presto, redshift, sap, snowflake, spark, sqlserver, synapse, trino, vertica"
}
