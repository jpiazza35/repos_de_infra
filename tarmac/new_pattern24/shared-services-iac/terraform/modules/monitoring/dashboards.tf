resource "kubernetes_config_map" "volumes-dashboard" {
  metadata {
    name      = "volumes-dashboard-alerting"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "dashboard.json" = "${file("${path.module}/grafana-dashboard/volume-alerting.json")}"
  }
}

resource "kubernetes_config_map" "node" {
  metadata {
    name      = "node"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "node.json" = "${file("${path.module}/grafana-dashboard/node.json")}"
  }
}
resource "kubernetes_config_map" "coredns" {
  metadata {
    name      = "coredns"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "coredns.json" = "${file("${path.module}/grafana-dashboard/coredns.json")}"
  }
}
resource "kubernetes_config_map" "api" {
  metadata {
    name      = "api"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "api.json" = "${file("${path.module}/grafana-dashboard/api.json")}"
  }
}
resource "kubernetes_config_map" "kubelet" {
  metadata {
    name      = "kubelet"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "kubelet.json" = "${file("${path.module}/grafana-dashboard/kubelet.json")}"
  }
}
resource "kubernetes_config_map" "proxy" {
  metadata {
    name      = "proxy"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "proxy.json" = "${file("${path.module}/grafana-dashboard/proxy.json")}"
  }
}
resource "kubernetes_config_map" "statefulsets" {
  metadata {
    name      = "statefulsets"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "statefulsets.json" = "${file("${path.module}/grafana-dashboard/statefulsets.json")}"
  }
}
resource "kubernetes_config_map" "persistent-volumes" {
  metadata {
    name      = "persistent-volumes"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "persistent-volumes.json" = "${file("${path.module}/grafana-dashboard/persistent-volumes.json")}"
  }
}
resource "kubernetes_config_map" "prometheous-overview" {
  metadata {
    name      = "prometheous-overview"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "prometheous-overview.json" = "${file("${path.module}/grafana-dashboard/prometheous-overview.json")}"
  }
}
resource "kubernetes_config_map" "use-method-cluster" {
  metadata {
    name      = "use-method-cluster"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "use-method-cluster.json" = "${file("${path.module}/grafana-dashboard/use-method-cluster.json")}"
  }
}
resource "kubernetes_config_map" "use-method-node" {
  metadata {
    name      = "use-method-node"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "use-method-node.json" = "${file("${path.module}/grafana-dashboard/use-method-node.json")}"
  }
}
#compute resources dashboard
resource "kubernetes_config_map" "compute-resources-cluster" {
  metadata {
    name      = "compute-resources-cluster"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "compute-resources-cluster.json" = "${file("${path.module}/grafana-dashboard/compute-resources-cluster.json")}"
  }
}
resource "kubernetes_config_map" "compute-resources-node-pods" {
  metadata {
    name      = "compute-resources-node-pods"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "compute-resources-node-pods.json" = "${file("${path.module}/grafana-dashboard/compute-resources-node-pods.json")}"
  }
}
resource "kubernetes_config_map" "compute-resources-pod" {
  metadata {
    name      = "compute-resources-pod"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "compute-resources-pod.json" = "${file("${path.module}/grafana-dashboard/compute-resources-pod.json")}"
  }
}
resource "kubernetes_config_map" "compute-resources-workload" {
  metadata {
    name      = "compute-resources-workload"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "compute-resources-workload.json" = "${file("${path.module}/grafana-dashboard/compute-resources-workload.json")}"
  }
}
resource "kubernetes_config_map" "compute-resources-namespace-workloads" {
  metadata {
    name      = "compute-resources-namespace-workloads"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "compute-resources-namespace-workloads.json" = "${file("${path.module}/grafana-dashboard/compute-resources-namespace-workloads.json")}"
  }
}
resource "kubernetes_config_map" "computer-resources-namespace-pods" {
  metadata {
    name      = "computer-resources-namespace-pods"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "computer-resources-namespace-pods.json" = "${file("${path.module}/grafana-dashboard/computer-resources-namespace-pods.json")}"
  }
}

#networking dashboard
resource "kubernetes_config_map" "networking-namespace-pods" {
  metadata {
    name      = "networking-namespace-pods"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "networking-namespace-pods.json" = "${file("${path.module}/grafana-dashboard/networking-namespace-pods.json")}"
  }
}
resource "kubernetes_config_map" "networking-namespace-workload" {
  metadata {
    name      = "networking-namespace-workload"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "networking-namespace-workload.json" = "${file("${path.module}/grafana-dashboard/networking-namespace-workload.json")}"
  }
}
resource "kubernetes_config_map" "networking-cluster" {
  metadata {
    name      = "networking-cluster"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "networking-cluster.json" = "${file("${path.module}/grafana-dashboard/networking-cluster.json")}"
  }
}
resource "kubernetes_config_map" "networking-pods" {
  metadata {
    name      = "networking-pods"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "networking-pods.json" = "${file("${path.module}/grafana-dashboard/networking-pods.json")}"
  }
}
resource "kubernetes_config_map" "networking-workload" {
  metadata {
    name      = "networking-workload"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "networking-workload.json" = "${file("${path.module}/grafana-dashboard/networking-workload.json")}"
  }
}

#Istio dashboard
resource "kubernetes_config_map" "istio-control-plane" {
  metadata {
    name      = "istio-control-plane"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "istio-control-plane.json" = "${file("${path.module}/grafana-dashboard/istio-control-plane.json")}"
  }
}
resource "kubernetes_config_map" "istio-mesh" {
  metadata {
    name      = "istio-mesh"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "istio-mesh.json" = "${file("${path.module}/grafana-dashboard/istio-mesh.json")}"
  }
}
resource "kubernetes_config_map" "istio-performance" {
  metadata {
    name      = "istio-performance"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "istio-performance.json" = "${file("${path.module}/grafana-dashboard/istio-performance.json")}"
  }
}
resource "kubernetes_config_map" "istio-service" {
  metadata {
    name      = "istio-service"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "istio-service.json" = "${file("${path.module}/grafana-dashboard/istio-service.json")}"
  }
}

resource "kubernetes_config_map" "istio-workload" {
  metadata {
    name      = "istio-workload"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "istio-workload.json" = "${file("${path.module}/grafana-dashboard/istio-workload.json")}"
  }
}

### AWS
resource "kubernetes_config_map" "aws-asg" {
  metadata {
    name      = "aws-autoscaling"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-autoscaling.json" = "${file("${path.module}/grafana-dashboard/aws-autoscaling.json")}"
  }
}

resource "kubernetes_config_map" "aws-acm" {
  metadata {
    name      = "aws-certificate-manager"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-certificate-manager.json" = "${file("${path.module}/grafana-dashboard/aws-certificate-manager.json")}"
  }
}
/* 
resource "kubernetes_config_map" "aws-cwb" {
  metadata {
    name      = "aws-cloudwatch-browser"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-cloudwatch-browser.json" = "${file("${path.module}/grafana-dashboard/aws-cloudwatch-browser.json")}"
  }
} */

resource "kubernetes_config_map" "aws-logs" {
  metadata {
    name      = "aws-cloudwatch-logs"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-cloudwatch-browser.json" = "${file("${path.module}/grafana-dashboard/aws-cloudwatch-logs.json")}"
  }
}
/* resource "kubernetes_config_map" "aws-cws" {
  metadata {
    name      = "aws-cloudwatch-synthetics"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-cloudwatch-synthetics.json" = "${file("${path.module}/grafana-dashboard/aws-cloudwatch-synthetics.json")}"
  }
} */

resource "kubernetes_config_map" "aws-cwu" {
  metadata {
    name      = "aws-cloudwatch-usage-metrics"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-cloudwatch-usage-metrics.json" = "${file("${path.module}/grafana-dashboard/aws-cloudwatch-usage-metrics.json")}"
  }
}

/* resource "kubernetes_config_map" "aws-codebuild" {
  metadata {
    name      = "aws-codebuild"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-codebuild.json" = "${file("${path.module}/grafana-dashboard/aws-codebuild.json")}"
  }
} */

resource "kubernetes_config_map" "aws-dynamodb" {
  metadata {
    name      = "aws-dynamodb"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-dynamodb.json" = "${file("${path.module}/grafana-dashboard/aws-dynamodb.json")}"
  }
}

resource "kubernetes_config_map" "aws-ebs" {
  metadata {
    name      = "aws-ebs"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-ebs.json" = "${file("${path.module}/grafana-dashboard/aws-ebs.json")}"
  }
}

resource "kubernetes_config_map" "aws-ec2" {
  metadata {
    name      = "aws-ec2"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-ec2.json" = "${file("${path.module}/grafana-dashboard/aws-ec2.json")}"
  }
}

resource "kubernetes_config_map" "aws-ecs" {
  metadata {
    name      = "aws-ecs"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-ecs.json" = "${file("${path.module}/grafana-dashboard/aws-ecs.json")}"
  }
}

resource "kubernetes_config_map" "aws-efs" {
  metadata {
    name      = "aws-efs"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-efs.json" = "${file("${path.module}/grafana-dashboard/aws-efs.json")}"
  }
}

resource "kubernetes_config_map" "aws-eks" {
  metadata {
    name      = "aws-eks"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-eks.json" = "${file("${path.module}/grafana-dashboard/aws-eks.json")}"
  }
}

resource "kubernetes_config_map" "aws-alb" {
  metadata {
    name      = "aws-alb"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-alb.json" = "${file("${path.module}/grafana-dashboard/aws-elb-application-lb.json")}"
  }
}

resource "kubernetes_config_map" "aws-elb" {
  metadata {
    name      = "aws-elb"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-elb.json" = "${file("${path.module}/grafana-dashboard/aws-elb-classic-lb.json")}"
  }
}

resource "kubernetes_config_map" "aws-eventbridge" {
  metadata {
    name      = "aws-eventbridge"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-eventbridge.json" = "${file("${path.module}/grafana-dashboard/aws-eventbridge.json")}"
  }
}

resource "kubernetes_config_map" "aws-lambda" {
  metadata {
    name      = "aws-lambda"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-lambda.json" = "${file("${path.module}/grafana-dashboard/aws-lambda.json")}"
  }
}

resource "kubernetes_config_map" "aws-rds" {
  metadata {
    name      = "aws-rds"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-rds.json" = "${file("${path.module}/grafana-dashboard/aws-rds.json")}"
  }
}

resource "kubernetes_config_map" "aws-r53" {
  metadata {
    name      = "aws-route-53"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-route-53.json" = "${file("${path.module}/grafana-dashboard/aws-route-53.json")}"
  }
}

resource "kubernetes_config_map" "aws-s3" {
  metadata {
    name      = "aws-s3"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-s3.json" = "${file("${path.module}/grafana-dashboard/aws-s3.json")}"
  }
}

resource "kubernetes_config_map" "aws-sns" {
  metadata {
    name      = "aws-sns"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-sns.json" = "${file("${path.module}/grafana-dashboard/aws-sns.json")}"
  }
}

resource "kubernetes_config_map" "aws-sqs" {
  metadata {
    name      = "aws-sqs"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-sqs.json" = "${file("${path.module}/grafana-dashboard/aws-sqs.json")}"
  }
}

resource "kubernetes_config_map" "aws-xray" {
  metadata {
    name      = "aws-xray"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-xray.json" = "${file("${path.module}/grafana-dashboard/aws-x-ray.json")}"
  }
}

resource "kubernetes_config_map" "aws-cni" {
  metadata {
    name      = "aws-cni"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-cni.json" = "${file("${path.module}/grafana-dashboard/aws-cni-metrics.json")}"
  }
}

resource "kubernetes_config_map" "aws-cluster" {
  metadata {
    name      = "aws-cluster"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "aws-cluster.json" = "${file("${path.module}/grafana-dashboard/kubernetes-eks-cluster.json")}"
  }
}

resource "kubernetes_config_map" "argocd" {
  metadata {
    name      = "argocd"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "argocd.json" = "${file("${path.module}/grafana-dashboard/argocd.json")}"
  }
}

resource "kubernetes_config_map" "cert_manager" {
  metadata {
    name      = "cert-manager"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "certmanager.json" = "${file("${path.module}/grafana-dashboard/cert_manager.json")}"
  }
}

resource "kubernetes_config_map" "mpt_dashboard" {
  metadata {
    name      = "mpt-dashboard"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "mpt-apps.json" = "${file("${path.module}/grafana-dashboard/mpt-apps.json")}"
  }
}

resource "kubernetes_config_map" "ping_monitoring" {
  metadata {
    name      = "ping-monitoring"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "ping-monitoring.json" = "${file("${path.module}/grafana-dashboard/ping-monitoring.json")}"
  }
}

resource "kubernetes_config_map" "kubectl_events_dashboard" {
  metadata {
    name      = "kubectl-events"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "kubectl-events-dashboard.json" = "${file("${path.module}/grafana-dashboard/kubectl-events-dashboard.json")}"
  }
}

/* 
resource "kubernetes_config_map" "k8s_cluster" {
  metadata {
    name      = "k8s-cluster"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "cluster.json" = "${file("${path.module}/grafana-dashboard/kubernetes-cluster.json")}"
  }
}

resource "kubernetes_config_map" "k8s_pods" {
  metadata {
    name      = "k8s-pods"
    namespace = var.monitoring_namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "pods.json" = "${file("${path.module}/grafana-dashboard/kubernetes-pods.json")}"
  }
} */
