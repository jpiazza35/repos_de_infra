# resource "null_resource" "grafana_ingress" {
#   triggers = {
#     ingress = sha256(data.template_file.grafana_ingress.rendered)
#   }
#   provisioner "local-exec" {
#     command = "kubectl apply -f -<<EOF\n${data.template_file.grafana_ingress.rendered}\nEOF"
#   }

# }

# data "template_file" "grafana_ingress" {
#   template = file("${path.module}/templates/grafana.yml")
#   vars     = {}

# }