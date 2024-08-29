### Istio
resource "local_file" "istio" {
  content = templatefile("${path.module}/templates/istio_manifests.yml.tpl", {
    env             = var.env
    acm_arn         = module.istio_acm.acm
    istio_namespace = kubernetes_namespace.istio_ingress.metadata[0].name
    istio_hostname  = var.istio_ingress_hostname
  })
  filename = "${path.module}/templates/istio_manifests.yml"
}

data "external" "istio_alb" {
  program = ["bash", "${path.module}/templates/istio_alb.sh"]

}

resource "local_file" "addon" {
  content = templatefile("${path.module}/templates/istio_addon.yml.tpl", {
    ns = kubernetes_namespace.istio_system.metadata[0].name
  })
  filename = "${path.module}/templates/istio_addon.yml"
}

data "aws_route53_zone" "selected" {
  provider     = aws.ss_network
  name         = var.cluster_domain_name
  private_zone = false
}

