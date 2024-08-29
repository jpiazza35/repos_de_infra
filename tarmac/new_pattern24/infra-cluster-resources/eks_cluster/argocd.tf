## Setup ArgoCD namespace

resource "null_resource" "argocd_namespace" {

  provisioner "local-exec" {
    command = "kubectl get namespace | grep -q argocd || kubectl create namespace argocd"
  }

  depends_on = [module.eks_mgmt]

}

## Installing CRDs for Appproject


data "http" "data_argo_crd" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/appproject-crd.yaml"
}

data "kubectl_file_documents" "document_argo_crd" {
  content = data.http.data_argo_crd.response_body
}

resource "kubectl_manifest" "argo_crd" {
  for_each  = data.kubectl_file_documents.document_argo_crd.manifests
  yaml_body = each.value

  depends_on = [module.eks_mgmt]

}

# ## Installing ArgoCD

resource "null_resource" "argo_bootstrap" {
  provisioner "local-exec" {
    command = <<-EOT
      cd kubernetes/platform/automation/argocd/overlays/environments/${var.environment}
      kustomize edit remove resource secrets
      kubectl apply -k .
    EOT
  }

  depends_on = [module.eks_mgmt]

}
