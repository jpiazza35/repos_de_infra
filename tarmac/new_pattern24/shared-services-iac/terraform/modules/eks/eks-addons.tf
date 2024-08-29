resource "aws_eks_addon" "coredns" {
  cluster_name                = var.cluster_name
  addon_name                  = "coredns"
  addon_version               = var.coredns_addon_version
  resolve_conflicts_on_create = "OVERWRITE"

  configuration_values = jsonencode({
    replicaCount = 2
    resources = {
      requests = {
        cpu    = "100m"
        memory = "150Mi"
      }
    }
  })

  depends_on = [aws_eks_node_group.main]

}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = var.cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_addon_version
  resolve_conflicts_on_create = "OVERWRITE"

  configuration_values = jsonencode({
    resources = {
      requests = {
        cpu    = "100m"
        memory = "150Mi"
      }
    }
  })

  depends_on = [aws_eks_node_group.main]

}


resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name                = var.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.ebs_csi_addon_version
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [aws_eks_node_group.main]

}

resource "kubectl_manifest" "gp3_storageclass" {
  yaml_body = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: gp3
allowVolumeExpansion: true
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
parameters:
  type: gp3
YAML

  depends_on = [
    aws_eks_addon.aws-ebs-csi-driver,
  ]
}