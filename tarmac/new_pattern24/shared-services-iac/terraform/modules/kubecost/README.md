## Kubecost

This module contains code for deploying the Kubecost helm chart to monitor and analyze Kubernetes resource spend within clusters. This includes setup for basic ingress, annotations for Application Load Balancer (ALB), Prometheus settings, and more.

To create resources using this module, incorporate the provided variable configurations in your Terraform setup. You can call this module in a `.tf` file like so:

```hcl
module kubecost {
  source = "git::https://github.com/your-repo-path/terraform/modules/kubecost"

  kubecost_release_name = var.kubecost_release_name
  kubecost_release_namespace = var.kubecost_release_namespace
  kubecost_chart_repository = var.kubecost_chart_repository
  kubecost_chart_name = var.kubecost_chart_name
  kubecost_storage_class = var.kubecost_storage_class
  kubecost_ingress_host = var.kubecost_ingress_host
  private_subnet_ids = var.private_subnet_ids
  ingress_alb_name = var.ingress_alb_name
  ingress_group_name = var.ingress_group_name
  environment = var.environment
}
```

The `values.yml` template file contains configurations for Kubecost components including Prometheus, Grafana, ingress settings, network costs, and persistent volume settings. Ensure that the variables passed match the expected types and values as defined in `variables.tf`.

For additional configurations or changes, consult the official [Kubecost documentation](https://github.com/kubecost/cost-analyzer-helm-chart).