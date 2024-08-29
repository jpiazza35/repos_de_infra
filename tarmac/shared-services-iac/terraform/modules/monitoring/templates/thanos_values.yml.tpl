serviceAccount:
  create: false
  name: ""
  automountServiceAccountToken: true
  annotations: {}

objstoreConfig: |-
  type: S3
  config:
    bucket: ${bucket}
    endpoint: s3.${region}.amazonaws.com

metrics:
  enabled: true
  serviceMonitor:
    enabled: true
    labels:
      prometheus-monitor: 'true'

storegateway:
  enabled: true
  persistence:
    size: 75Gi
  podAnnotations:
    "meta.helm.sh/release-namespace": ${namespace}
    iam.amazonaws.com/role: "${monitoring_aws_role}"
  extraFlags:
    - --min-time=-12w

query:
  stores:
    - kube-prometheus-stack-operator.monitoring.svc:10250

ruler:
  enabled: true
  podAnnotations:
    "meta.helm.sh/release-namespace": ${namespace}
    iam.amazonaws.com/role: "${monitoring_aws_role}"
  alertmanagers:
    - "http://alertmanager-operated.${namespace}.svc:9093"
  existingConfigmap: prometheus-monitor-kube-prometheus-st-prometheus-rulefiles-0
  clusterName: "${clusterName}"
  persistence:
    enabled: false

compactor:
  enabled:  ${enabled_compact}
  retentionResolutionRaw: 30d
  retentionResolution5m: 183d
  retentionResolution1h: 365d
  persistence:
    size: 50Gi
    accessModes:
      - ReadWriteOnce

bucketweb:
  enabled: true

receive:
  enabled: true
