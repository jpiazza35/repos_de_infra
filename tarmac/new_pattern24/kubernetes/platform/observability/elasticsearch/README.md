## Elasticsearch

This directory contains the Elasticsearch configuration for the observability platform.

The Elasticsearch cluster is deployed using the [Elasticsearch Operator](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html). The operator is installed via Helm and the chart is located in the [elasticsearch-operator](../elasticsearch-operator) directory.

The controller installs CRDs, including the elasticsearch cluster CRD, and a controller that watches for the cluster CRD and deploys the cluster.

The Elasticsearch cluster is deployed in the `monitoring` namespace and deploys a single leader, client, and data node. The cluster is configured to use a `4Gi` persistent volume claim.
