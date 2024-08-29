config = {
  vpc_id = "vpc-0d4a71d5bd8b2ee23"
  ec2_ami_id        = "ami-02396cdd13e9a1257"
  ec2_instance_type = "t3.micro"
  ec2_ssh_key_name  = "d_nexla_poc_ssh"

  allow_ingress = {
    SSH = {
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = [
        # NEXLA Public ips
        "34.231.167.112/32",
        "54.209.27.1/32",
        #Sullivan cotter private network
        "10.0.0.0/8"
      ]
    }
  }

  allow_egress = {
    SSH = {
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = [
        # NEXLA Public ips
        "34.231.167.112/32",
        "54.209.27.1/32",
        #Sullivan cotter private network
        "10.0.0.0/8"
      ]
    }
    PostgreSQL = {
      from_port  = 5432
      to_port    = 5432
      protocol   = "tcp"
      cidr_block = [
        # NEXLA Public ips
        "34.231.167.112/32",
        "54.209.27.1/32",
        #Sullivan cotter private network
        "10.0.0.0/8"
      ]
    }
    MSSQL = {
      from_port  = 1433
      to_port    = 1433
      protocol   = "tcp"
      cidr_block = [
        # NEXLA Public ips
        "34.231.167.112/32",
        "54.209.27.1/32",
        #Sullivan cotter private network
        "10.0.0.0/8"
      ]
    }
  }
}
