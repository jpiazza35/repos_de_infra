##############
# LimitRange #
##############

resource "kubernetes_limit_range" "monitoring" {
  metadata {
    name      = "limitrange"
    namespace = var.monitoring_namespace
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "1600m"
        memory = "24Gi"
      }
      default_request = {
        cpu    = "10m"
        memory = "100Mi"
      }
    }
  }
}

###################
# Resource Quotas #
###################

resource "kubernetes_resource_quota" "monitoring" {
  metadata {
    name      = "namespace-quota"
    namespace = var.monitoring_namespace
  }
  spec {
    hard = {
      pods = 150
    }
  }
}

####################
# Network Policies #
####################

resource "kubernetes_network_policy" "default" {
  metadata {
    name      = "default"
    namespace = var.monitoring_namespace
  }

  spec {
    pod_selector {}
    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_ingress_controllers" {
  metadata {
    name      = "allow-ingress-controllers"
    namespace = var.monitoring_namespace
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            component = "ingress-controllers"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_kube_api" {
  metadata {
    name      = "allow-kube-api"
    namespace = var.monitoring_namespace
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            component = "kube-system"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_alertmanager_api" {
  metadata {
    name      = "allow-alertmanager-api"
    namespace = var.monitoring_namespace
  }

  spec {
    pod_selector {
      match_labels = {
        app = "alertmanager"
      }
    }
    ingress {
      from {
        namespace_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}
