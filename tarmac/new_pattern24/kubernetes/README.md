# Kubernetes

This repository is the source of truth for the Clinician Nexus Kubernetes platform. In this repository you will find a mix of raw kubernetes manifests, kustomize, and helm application manifests.

These manifests [could be be] automatically synchronized to the clusters via ArgoCD using the GitOps methodology:

<p align="center">
  <img width="697" alt="image" src="https://github.com/clinician-nexus/kubernetes/assets/133695630/19d4d105-d24c-4b3c-aff7-25c0de3afb05">
</p>

## What is GitOps?

GitOps is a method of Kubernetes cluster management and application delivery. It works by using [Git](https://git-scm.com) as a single source of truth for [declarative infrastructure and applications](https://en.wikipedia.org/wiki/Infrastructure_as_code), together with tools ensuring the actual state of infrastructure and applications converges towards the desired state declared in Git. With Git at the center of your delivery pipelines, developers can make pull requests to accelerate and simplify application deployments and operations tasks to your infrastructure or container-orchestration system (e.g. Kubernetes).

Certainly, adding a section about the "App of Apps" pattern can provide clarity on how ArgoCD Applications and ApplicationSets are used to manage deployments in your Kubernetes environment. Below is a draft for the section you can add to your README.

---

## App of Apps Pattern with ArgoCD

### Overview

The "App of Apps" pattern is a deployment strategy that we employ to streamline and centralize the management of multiple ArgoCD Applications within our Kubernetes environment. In essence, we deploy a top-level ArgoCD Application that points to an ArgoCD ApplicationSet. This ApplicationSet then dynamically generates ArgoCD Applications for each of our actual deployed Kubernetes applications.

<p align="center">
  <img width="697" alt="image" src="https://github.com/clinician-nexus/kubernetes/assets/133695630/7eb99f3e-8f61-4785-855e-3376b7779acc">
</p>

### Benefits

- **Centralized Management**: One "parent" Application to manage multiple "child" Applications.
- **Dynamic Generation**: ApplicationSets allow for dynamic generation of Applications based on different parameters, reducing manual configuration.
- **Streamlined Updates**: Update the parent Application to trigger synchronized updates across all child Applications.

## Documentation

For more details on specific topics, see the following guides:

- [Adding an Application](docs/AddAnApp.md): Step-by-step guide on how to add new applications to this repository.
- [Modifying an Existing Application](docs/ModifyAnApp.md): Instructions for safely modifying already deployed applications.
- [Testing Changes](docs/TestingChanges.md): How to test different layers of your configuration to ensure they are correctly set up.
