sso = {
  securityadmin = {
    role  = "AWSReadOnlyAccess"
    group = "aws_global_securityadmin"
  },
  securityauditor = {
    role  = "AWSReadOnlyAccess"
    group = "aws_global_securityauditor"
  },
  readonly = {
    role  = "AWSReadOnlyAccess"
    group = "aws_global_readonly"
  },
  superadmin = {
    role  = "AWSAdministratorAccess"
    group = "aws_global_superadmin"
  },
  abac = {
    role  = "AWS-Global-ABAC-Dynamic-Access"
    group = "aws_global_abac"
  },
  devopsreadonly = {
    role  = "AWSReadOnlyAccess"
    group = "aws_global_tarmac_devops"
  },
}

# Tags to apply to all resources created in this project.
tags = {
  "cn:team" = "devops"
  "cn:iac"  = "aft-terraform"
}

vpc_parameters = {
  networking = {
    org_cidr_block       = "10.0.0.0/8"
    transit_vpc_cidr     = "0.0.0.0/0"
    secondary_cidr_block = "100.64.0.0/16"
  }
  max_subnet_count = 3
  azs              = []
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
      private_dns_enabled = true
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
    elasticfilesystem = {
      service             = "elasticfilesystem"
      service_name        = null
      service_type        = "Interface"
      private_dns_enabled = true
      tags = {
        Name = "elasticfilesystem-vpc-endpoint"
      }
    }
    execute-api = {
      service             = "execute-api"
      service_name        = null
      service_type        = "Interface"
      private_dns_enabled = true
      tags = {
        Name = "apigateway-vpc-endpoint"
      }
    }
  }
}
