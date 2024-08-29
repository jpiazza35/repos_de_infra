### First step after EKS deployment

resource "null_resource" "kubectl_update" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
  }
  depends_on = [module.eks]
}

### Annotate nodes

resource "null_resource" "annotate_nodes" {

  provisioner "local-exec" {
    working_dir = "${path.module}/files"
    command     = <<EOH
chmod 0755 annotate-nodes.sh
./annotate-nodes.sh
EOH
  }

  depends_on = [
    null_resource.kubectl_update
  ]
}


### ENI config

resource "helm_release" "vpc-cni-helm" {
  name            = "aws-vpc-cni"
  namespace       = "kube-system"
  cleanup_on_fail = true
  repository      = "https://aws.github.io/eks-charts"
  chart           = "aws-vpc-cni"

  set {
    name  = "image.region"
    value = var.aws_region
  }

  set {
    name  = "init.image.region"
    value = var.aws_region
  }

  values = [
    templatefile("${path.module}/files/helm_cni_values.yaml", {
      aws_region     = var.aws_region
      security_group = aws_security_group.eks_node_group_sg.id

      az0_id = data.aws_subnet.selected_private_1.availability_zone
      az1_id = data.aws_subnet.selected_private_2.availability_zone
      az2_id = data.aws_subnet.selected_private_3.availability_zone

      az0_subnet_id = data.aws_subnet.selected_private_1.id
      az1_subnet_id = data.aws_subnet.selected_private_2.id
      az2_subnet_id = data.aws_subnet.selected_private_3.id

    })
  ]

  depends_on = [null_resource.annotate_nodes, module.eks]
}


### Cycle nodes

resource "null_resource" "cycle_nodes" {

  provisioner "local-exec" {
    working_dir = "${path.module}/files"
    command     = <<EOH
chmod 0755 cycle-nodes.sh
./cycle-nodes.sh -c ${var.cluster_name}
EOH
  }
  depends_on = [
    helm_release.vpc-cni-helm
  ]
}

output "node_security_group" {
  description = "nodes sg id"
  value       = aws_security_group.eks_node_group_sg.id
}

