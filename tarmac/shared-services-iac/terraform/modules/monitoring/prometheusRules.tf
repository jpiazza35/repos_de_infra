resource "kubernetes_manifest" "prometheusrule_certificate_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "certificate-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "certificate-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/certificate_alerts/certificate_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_certmanager_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "certmanager-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "certmanager-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/certificate_alerts/certmanager.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_container_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "container-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "container-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/container_alerts/container_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_job_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "job-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "job-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/job_alerts/job_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_node_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "node-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "node-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/node_alerts/node_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_nodepool_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "nodepool-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "nodepool-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/nodepool_alerts/nodepool_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_pod_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "pod-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "pod-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/pod_alerts/pod_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_prometheus_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "prometheus-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "prometheus-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/prometheus_alerts/prometheus_rules.yaml", {
      prometheus_pvc_name = var.prometheus_pvc_name
      runbook_base_url    = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_coredns_alerts" {
  count = var.enable_prometheus_rules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"        = "coredns-alerts"
      "namespace"   = var.monitoring_namespace
      "labels"      = merge(local.common_labels, { "app.kubernetes.io/name" = "coredns-alerts" })
      "annotations" = {}
    }
    "spec" = yamldecode(file("${path.module}/prometheus_rules/coredns_alerts/coredns_rules.yaml"))
  }
}
