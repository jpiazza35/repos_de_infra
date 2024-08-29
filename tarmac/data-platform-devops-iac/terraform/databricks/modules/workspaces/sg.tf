resource "aws_security_group" "databricks_private_link" {

  name        = "databricks_private_link"
  description = "Allow traffic to support Databricks Private Link"
  vpc_id      = var.vpc_id

  ingress {
    description = "Databricks infrastructure, cloud data sources, and library repositories"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "All traffic from Clinician Nexus"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }

  ingress {
    description = "Metastore"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "PrivateLink"
    from_port   = 6666
    to_port     = 6666
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Compliance security profile"
    from_port   = 2443
    to_port     = 2443
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "databricks"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "databricks"
    from_port   = 1025
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "databricks_private_link"
  }
}
