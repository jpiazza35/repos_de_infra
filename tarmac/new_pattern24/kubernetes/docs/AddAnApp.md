# Adding Applications to This Repository

## Overview

This section provides a step-by-step guide on how to add new applications to this repository, ensuring they adhere to the existing structure and are compatible with our GitOps workflow via ArgoCD.

## Prerequisites

- Familiarity with Kubernetes, Kustomize, and Helm
- Access to this Git repository
- Installed `kubectl` and `kustomize` CLI tools

## Application vs Platform Type of Apps

Before adding a new app, determine its type:

**Application Type:** User-facing services with business logic. Under /applications directory.

**Platform Type:** Infrastructure and operational tools. Under /platform directory.

## Steps

### 1. Choose or Create Application Directory

Navigate to the `applications` directory. If your application's name is `my-app`, either:

- Create a new directory named `my-app`
- Inside this directory, create `base` and `overlays` directories

```bash
my-app
├── base
└── overlays
    └── environments
        ├── dev
        ├── prod
        └── qa
```

### 2. Add Base Manifests

- Inside the `base` directory, add your Kubernetes manifests. This could be raw YAML files, Kustomize manifests, or Helm charts.

### 3. Configure Overlays

- Navigate to the `overlays` directory and set up environment-specific overlays like `dev`, `prod`, `qa`.

### 4. Add Environment-Specific Configurations

- Customize the overlays for each environment. You may include patches, environment-specific configs, or secret references.

### 5. Update ArgoCD ApplicationSet

- Update the corresponding `applicationset.yaml` under `_argo-applicationset/environments/{env}/applicationset.yaml`.

### 7. Pull Request and Review

- Open a pull request for code review. Once approved, the new application will automatically sync via ArgoCD.

## Conclusion

You've successfully added an application to this repository. It should now be part of our GitOps workflow, managed and deployed via ArgoCD.
