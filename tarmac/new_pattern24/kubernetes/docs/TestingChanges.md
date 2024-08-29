# Testing Different Configuration Layers

## Overview

To ensure that the different layers of your application's Kubernetes configuration build correctly, you can test them locally before pushing the changes to this repository.

## Steps

### 1. Test a Layer

- Navigate to the a directory (base/env/prod/etc) of your application and run:

  ```bash
  kustomize build --enable-helm .
  ```
  
- This will validate that your manifests are correctly configured.

## Conclusion

By running these tests, you can catch any errors or misconfigurations early in the development process, ensuring that your application manifests are ready for deployment via ArgoCD.
