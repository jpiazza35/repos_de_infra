env         = "prod"
app         = "trustgrid"
asg_min     = 1
asg_max     = 2
asg_desired = 1
eni = {
  management = 0
  data       = 1
}
vol_size          = 30
instance_type     = "t3.medium"
retention_in_days = 30

additional_sg_rules = [
  {
    type        = "ingress"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "PostgreSQL Access"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  },
  {
    type        = "ingress"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    description = "Redshift Access"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  },
  {
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS Access"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  },
  {
    type        = "ingress"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    description = "Port 1443 Access"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  },
  {
    type        = "ingress"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    description = "Port 9000 Access"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }
]
