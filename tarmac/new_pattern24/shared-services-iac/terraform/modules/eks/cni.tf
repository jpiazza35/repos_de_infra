### Annotate nodes

resource "null_resource" "sleep" {

  provisioner "local-exec" {
    command = "sleep 10"
  }

  depends_on = [
    aws_eks_node_group.main
  ]

}


resource "null_resource" "annotate_nodes" {

  provisioner "local-exec" {
    working_dir = "${path.module}/files"
    command     = <<EOH
chmod 0755 annotate-nodes.sh
./annotate-nodes.sh
EOH
  }

  depends_on = [
    null_resource.sleep
  ]
}


### ENI config

resource "helm_release" "vpc-cni-helm" {
  name            = "aws-vpc-cni"
  namespace       = "kube-system"
  cleanup_on_fail = true
  repository      = "https://aws.github.io/eks-charts"
  chart           = "aws-vpc-cni"

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

  depends_on = [null_resource.annotate_nodes, aws_eks_cluster.eks, aws_eks_node_group.main]
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

