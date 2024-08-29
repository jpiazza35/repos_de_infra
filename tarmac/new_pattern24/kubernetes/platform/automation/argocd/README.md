# ArgoCD

[ArgoCD](https://github.com/argoproj/argo-cd) is a declarative, GitOps continuous delivery tool for Kubernetes.

## Installation Steps

### Step 1: Authenticate to Cluster

First, authenticate to your cluster.

### Step 2: Install ArgoCD

Run the following command to install ArgoCD:

```bash
kubectl apply -k platform/automation/argocd/overlays/environments/dev
```

### Step 3: Deploy Argo ApplicationSet Applications

Run the following command to deploy ArgoCD platform applications:

```bash
kubectl apply -f platform/_argo-applicationset/argocd/dev/application.yaml
```

### Step 4: Deploy ArgoCD Applications

Run the following command to deploy ArgoCD business applications:

```bash
kubectl apply -f applications/_argo-applicationset/argocd/dev/application.yaml
```

These steps should ideally be automated with Terraform during cluster creation.
