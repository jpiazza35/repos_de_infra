# Organization to build the network for
org_arn = "arn:aws:organizations::581369176057:organization/o-bahsnuabqc"

# Tags to apply to all resources created in this project.
tags = {
  Environment = "shared_services"
  App         = "tgw"
  Resource    = "Managed by Terraform"
  Description = "Network Configuration"
  Team        = "DevOps"
  Service     = "infrastructure"
  SourceCode  = "aws-networking"
}

# Name of AWS account associated with this project
aws_account_name = "SS_NETWORK"

# ID of DX Connection
dx_id = "dxcon-ffoxhzkg" # AWS_VA-QTS_Chicago

# Amazon side ASN of BGP direct connect peering
dx_aws_asn = 65500

# Customer side ASN of BGP direct connect peering
dx_cx_asn = 65100

# vLAN ID of the direct connect peering interfaces
dx_vlan = 100

# AWS Side BGP Peer IP
dx_aws_address = "10.100.1.17/29"

# Customer side BGP Peer IP
dx_cx_address = "10.100.1.18/29"

# AWS CIDRs to advertise to Direct Connect BGP Peer
dx_prefixes = {
  us-east-1 = [
    "10.200.0.0/16",
    "10.201.0.0/16",
    "10.202.0.0/16",
  ],
  us-east-2 = [
    "10.203.0.0/16",
    "10.204.0.0/16",
    "10.205.0.0/16",
    "10.206.0.0/16",
    "10.207.0.0/16",
    "10.208.0.0/16",
    "10.209.0.0/16"
  ]
}

dx_auth_key = "po3OfvVxQ8S8ppHx7xWnxFLrg"

### TO UPDATE ONCE ROUTE 53 ZONES ARE MIGRATED/SHARED
route53_forwarding_zones = {
  "sca.local" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "sts.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "vhpsndhqkh.execute-api.us-east-1.amazonaws.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "cloud.databricks.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "cn-sdlc-databricks.cloud.databricks.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "cn-prod-databricks.cloud.databricks.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "dbc-45913da4-d2bf.cloud.databricks.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "dev.cliniciannexus.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "dev1.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "dev2.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "qa1.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "test1.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "test2.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "test3.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
  "stage1.sullivancotter.com" = [
    "10.200.11.33",
    "10.200.12.33"
  ],
}

endpoints = {
  s3 = {
    service             = "s3"
    service_name        = null
    service_type        = "Gateway"
    private_dns_enabled = true
    tags = {
      Name = "s3-vpc-endpoint"
    }
  },
  dynamodb = {
    service             = "dynamodb"
    service_name        = null
    service_type        = "Gateway"
    private_dns_enabled = null
    tags = {
      Name = "dynamodb-vpc-endpoint"
    }
  },
  sns = {
    service             = "sns"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = null
    tags = {
      Name = "sns-vpc-endpoint"
    }
  },
  sqs = {
    service             = "sqs"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "sqs-vpc-endpoint"
    }
  },
  sts = {
    service             = "sts"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "sts-vpc-endpoint"
    }
  },
  kinesis-streams = {
    service             = "kinesis-streams"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "kinesis-vpc-endpoint"
    }
  }
  ssm = {
    service             = "ssm"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "ssm-vpc-endpoint"
    }
  }
  ssmmessages = {
    service             = "ssmmessages"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "ssmmessages-vpc-endpoint"
    }
  }
  ec2messages = {
    service             = "ec2messages"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "ec2messages-vpc-endpoint"
    }
  }
  kms = {
    service             = "kms"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "kms-vpc-endpoint"
    }
  }
  logs = {
    service             = "logs"
    service_name        = null
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "logs-vpc-endpoint"
    }
  }
}
