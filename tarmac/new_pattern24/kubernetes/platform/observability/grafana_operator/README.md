# Grafana Operator Deployment

This folder contains the configuration files necessary for deploying and operating  [Grafana operator](https://github.com/grafana-operator/grafana-operator) in a Kubernetes environment using Kustomize.

## Components

- `grafana_agent.yml`: Configuration for the Grafana agent, responsible for collecting metrics and logs.
- `integrations.yml`: Defines integrations with other tools or services.
- `kustomization.yml`: Kustomize files for configuration customization.
- `logs_instance.yml`: Configuration for the instance managing logs.
- `metrics_instance.yml`: Configuration for the instance managing metrics.
- `pod_logs.yml`: Definitions for collecting pod-level logs.
- `pv.yml`: Persistent Volume (PV) definitions for storage.
- `rbac.yml`: Role-Based Access Control (RBAC) configurations.
- `service_monitor.yml`: Configuration for service monitoring.
- `serviceaccount.yml`: Service account for Grafana operations.

## folder Intention

The purpose of this folder is to provide a modular and reusable way to deploy Grafana, facilitating the observability of the platform. This includes monitoring of metrics and logs, as well as integrations with alerting systems and dashboards.

## Directory Structure

Below is an overview of the directory structure and a brief explanation of each folder:

- `base`: Contains the foundational Kubernetes manifests that are common to all environments.
  - `agent`: Houses the configurations for the Grafana agent.
    - `grafana_agent.yml`: The main configuration for the Grafana agent.
    - `integrations.yml`: Integrations with other services.
    - `kustomization.yml`: Kustomize configuration for base resource customization.
    - `logs_instance.yml`: Configuration for logging instances.
    - `metrics_instance.yml`: Configuration for metrics instances.
    - `pod_logs.yml`: Collection setup for pod-level logging.
    - `pv.yml`: Persistent Volume configurations.
    - `rbac.yml`: Role-Based Access Control settings.
    - `service_monitor.yml`: Service Monitor setup for Prometheus operator.
    - `serviceaccount.yml`: Service account specifics for Grafana agent.
    - `kustomization.yml`: Kustomize setup for Helm charts, it install the base helmchart, then all CRDs unser agent folder, finally it applies patches over spec.images for GrafanaAgent . 
    - `values.yml`: Value overrides for Helm charts.
- `overlays`: Environment-specific modifications and values.
  - `environments`: Individual directories for each environment such as dev, devops, prod, etc.
    - `dev`: Development environment-specific overrides.
    - `devops`: DevOps team's environment-specific overrides.
    - `prod`: Production environment-specific overrides.
    - `qa`: QA environment-specific overrides.
    - `sharedservices`: Overrides for shared services across environments.
- `secrets`: Contains Kustomize setups for managing secrets.
  - `kustomization.yml`: Base Kustomize configuration for secrets.
  - `logs.yml`: Secret configurations for logging.
  - `metrics.yml`: Secret configurations for metrics.

Each environment under `overlays/environments` can be customized with its own `kustomization.yml`, allowing for flexible deployments tailored to the needs of that specific environment.
