## Number of replicas
replicaCount: 1

## Additional container arguments
extraArgs:
  - --enable-insecure-login

## Serve application over HTTP without TLS
##
## Note: If set to true, you may want to add --enable-insecure-login to extraArgs
protocolHttp: true

service:
  type: ClusterIP
  # Dashboard service port
  externalPort: 8001

## Metrics Scraper
## Container to scrape, store, and retrieve a window of time from the Metrics Server.
## refs: https://github.com/kubernetes-sigs/dashboard-metrics-scraper
metricsScraper:
  ## Whether to enable dashboard-metrics-scraper
  enabled: true

metrics-server:
  enabled: false

rbac:
  create: true
  clusterReadOnlyRole: true

serviceAccount:
  # Specifies whether a service account should be created
  create: false
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: kubernetes-dashboard

serviceMonitor:
  enabled: true
  ## Here labels can be added to the serviceMonitor
  labels:
    release: ${prometheus_release_name}