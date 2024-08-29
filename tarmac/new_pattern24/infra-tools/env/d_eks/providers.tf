resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.k8s_cluster_name} --region ${var.aws_region} --kubeconfig ${path.module}/kubeconfig.yaml"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.env
      Product     = var.product
      Repository  = "https://github.com/clinician-nexus/infra-tools"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig.yaml"
  }
}

provider "kubernetes" {
  #load_config_file       = false
  config_path = "${path.module}/kubeconfig.yaml"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-us-east-1-946884638317"
    key            = "infra-tools.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    encrypt        = true
  }
}
