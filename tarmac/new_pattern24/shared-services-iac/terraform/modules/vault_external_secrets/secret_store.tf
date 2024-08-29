resource "kubectl_manifest" "external_secrets_cluster_store" {
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "${var.vault_url}"
      path: "${var.env}"
      version: "v1"
      auth:
        kubernetes:
          mountPath: "${var.cluster_name}"
          role: "${var.cluster_name}"
          serviceAccountRef:
            name: vault-auth
            namespace: default
YAML
}
