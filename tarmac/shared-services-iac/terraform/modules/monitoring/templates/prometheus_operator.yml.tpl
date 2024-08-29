defaultRules:
  create: false
  rules:
    kubeScheduler: true
    etcd: true
    general: true
    kubernetesApps: true
    rubookUrl: true
    k8s: true
    kubeApiserver: true
    kubeApiserverAvailability: true
    kubeApiserverError: true
    kubeApiserverSlos: true
    kubelet: true
    kubePrometheusGeneral: true
    kubePrometheusNodeAlerting: true
    kubePrometheusNodeRecording: true
    kubernetesAbsent: true
    kubernetesResources: true
    kubernetesStorage: true
    kubernetesSystem: true
    kubeStateMetrics: true
    network: true
    node: true
    prometheus: true
    prometheusOperator: true
    time: true

additionalPrometheusRulesMap:
  rules:
    groups:
    - name: Pod Resource Alerts
      rules:
      - alert: High Pod Memory
        expr: sum(container_memory_usage_bytes) > 60000000000 #60GB
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: High Memory Usage
          message: "{{ $labels.name }} Memory usage at {{ humanize $value }}%"
      
      - alert: High Pod CPU
        expr: sum(rate(container_cpu_usage_seconds_total[1m])) / count(node_cpu_seconds_total{mode="system"}) * 100 > 60
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: High CPU Usage
          message: "{{ $labels.name }} CPU usage at {{ humanize $value }}%"

    - name: Host
      rules:
      - alert: HostDown
        expr: up == 0
        for: 1m
        labels:
          severity: "critical"
        annotations:
          summary: "Endpoint {{ $labels.instance }} down"
          message: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minutes."

      - alert: HostOutOfMemory
        expr: node_memory_MemAvailable / node_memory_MemTotal * 100 < 25
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Host out of memory (instance {{ $labels.instance }})"
          message: "Node memory is filling up (< 25% left)\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

      - alert: HostOutOfDiskSpace
        expr: (node_filesystem_avail{mountpoint="/"}  * 100) / node_filesystem_size{mountpoint="/"} < 50
        for: 1s
        labels:
          severity: warning
        annotations:
          summary: "Host out of disk space (instance {{ $labels.instance }})"
          message: "Disk is almost full (< 50% left)\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

      - alert: HostHighCpuLoad
        expr: (sum by (instance) (irate(node_cpu{job="node_exporter_metrics",mode="idle"}[5m]))) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Host high CPU load (instance {{ $labels.instance }})"
          message: "CPU load is > 80%\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

      - alert: DiskSpaceFree10Percent
        expr: node_filesystem_free_percent <= 10
        labels:
          severity: warning
        annotations:
          summary: "Instance [{{ $labels.instance }}] has 10% or less Free disk space"
          message: "[{{ $labels.instance }}] has only {{ $value }}% or less free."
    - name: KubeStateMetrics
      rules:
      - alert: KubeStateMetricsListErrors
        annotations:
          message: kube-state-metrics is experiencing errors at an elevated rate in list operations. This is likely causing it to not be able to expose metrics about Kubernetes objects correctly or at all.
          summary: kube-state-metrics is experiencing errors in list operations.
        expr: |
          (sum(rate(kube_state_metrics_list_total{job="kube-state-metrics",result="error"}[5m]))
            /
          sum(rate(kube_state_metrics_list_total{job="kube-state-metrics"}[5m])))
          > 0.01
        for: 15m
        labels:
          severity: critical
      - alert: KubeStateMetricsWatchErrors
        annotations:
          message: kube-state-metrics is experiencing errors at an elevated rate in watch operations. This is likely causing it to not be able to expose metrics about Kubernetes objects correctly or at all.
          summary: kube-state-metrics is experiencing errors in watch operations.
        expr: |
          (sum(rate(kube_state_metrics_watch_total{job="kube-state-metrics",result="error"}[5m]))
            /
          sum(rate(kube_state_metrics_watch_total{job="kube-state-metrics"}[5m])))
          > 0.01
        for: 15m
        labels:
          severity: critical
      - alert: KubeStateMetricsShardingMismatch
        annotations:
          message: kube-state-metrics pods are running with different --total-shards configuration, some Kubernetes objects may be exposed multiple times or not exposed at all.
          summary: kube-state-metrics sharding is misconfigured.
        expr: |
          stdvar (kube_state_metrics_total_shards{job="kube-state-metrics"}) != 0
        for: 15m
        labels:
          severity: critical
      - alert: KubeStateMetricsShardsMissing
        annotations:
          message: kube-state-metrics shards are missing, some Kubernetes objects are not being exposed.
          summary: kube-state-metrics shards are missing.
        expr: |
          2^max(kube_state_metrics_total_shards{job="kube-state-metrics"}) - 1
            -
          sum( 2 ^ max by (shard_ordinal) (kube_state_metrics_shard_ordinal{job="kube-state-metrics"}) )
          != 0
        for: 15m
        labels:
          severity: critical

    - name: k8s.rules
      rules:
      - record: node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate
        expr: sum(irate(container_cpu_usage_seconds_total[5m])) by (node, namespace, pod, container)

      - record: node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate
        expr: sum(rate(container_cpu_usage_seconds_total[5m])) by (node, namespace, pod, container)

      - record: node_namespace_pod_container:container_memory_working_set_bytes
        expr: container_memory_working_set_bytes{node=~"$node", container!=""} * on (cluster, namespace, pod) group_left(node) topk by(cluster, namespace, pod) (1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=""}))
  
      - record: node_namespace_pod_container:container_memory_rss
        expr: sum(container_memory_rss) by (node, namespace, pod, container)

      - record: node_namespace_pod_container:container_memory_cache
        expr: sum(container_memory_cache) by (node, namespace, pod, container)

      - record: node_namespace_pod_container:container_memory_swap
        expr: sum(container_memory_swap) by (node, namespace, pod, container)

      - record: node_memory_MemAvailable_bytes:sum
        expr: sum(node_memory_MemAvailable_bytes)

      - record: cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests
        expr: kube_pod_container_resource_requests{namespace="$namespace", resource="cpu", job="kube-state-metrics"}  * on (pod) group_left() max by (pod) ((kube_pod_status_phase{phase=~"Pending|Running"} == 1))

      - record: cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits
        expr: kube_pod_container_resource_limits{namespace="$namespace", resource="cpu", job="kube-state-metrics"}  * on (pod) group_left() max by (pod) ((kube_pod_status_phase{phase=~"Pending|Running"} == 1))

      - record: namespace_workload_pod:kube_pod_owner:relabel
        expr: sum(irate(kube_pod_owner[5m])) by (namespace, workload, pod)

alertmanager:
  enabled: true

  annotations:
    "meta.helm.sh/release-namespace": ${namespace}

  apiVersion: v2

  serviceAccount:
    create: true

  ingress:
    enabled: false
    # ingressClassName: "istio"
    pathType: ""
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      cert-manager.io/cluster-issuer: vault-cert-issuer #letsencrypt-${environment}
      kubernetes.io/ingress.class: istio
      alb.ingress.kubernetes.io/group.name: "devops"
      external-dns.alpha.kubernetes.io/hostname: monitoring.devops.cliniciannexus.com
    hosts:
    - "${alertmanager_ingress}"
    paths:
    - /alert
    tls:
      - secretName: "alertmanager"
        hosts:
        - "${alertmanager_ingress}"

  config:
    global:
      slack_api_url: https://hooks.slack.com/services/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

    templates:
    - '/etc/alertmanager/config/*.tmpl'
    
    route:
      receiver: 'null'
      group_by: ['alertname', 'priority', 'job']
      group_wait: 10s
      group_interval: 5m
      repeat_interval: 1h
      routes:
      - match:
          alertname: Watchdog
        receiver: 'null'
      - receiver: 'slack-notifications'
        continue: true
 
    receivers:
    - name: 'null'
    - name: 'slack-notifications'
      slack_configs:
      - channel: '#monitoring-alerts'
        icon_url: https://avatars3.githubusercontent.com/u/3380462
        title: '{{ template "slack.cp.title" . }}'
        text: '{{ template "slack.cp.text" . }}'
        color: '{{ template "slack.color" . }}'
        send_resolved: true
        actions:
          - type: button
            text: 'Runbook :green_book:'
            url: '{{ (index .Alerts 0).Annotations.runbook_url }}'
          - type: button
            text: 'Query :mag:'
            url: '{{ (index .Alerts 0).GeneratorURL }}'
          - type: button
            text: 'Dashboard :chart_with_upwards_trend:'
            url: '{{ (index .Alerts 0).Annotations.dashboard_url }}'
          - type: button
            text: 'Silence :no_bell:'
            url: '{{ template "__alert_silence_link" . }}'

  templateFiles:
    cp-slack-templates.tmpl: |-
      {{ define "slack.cp.title" -}}
        [{{ .Status | toUpper -}}
        {{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{- end -}}
        ] {{ template "__alert_severity_prefix_title" . }} {{ .CommonLabels.alertname }}
      {{- end }}

      {{/* The text to display in the alert */}}
      {{ define "slack.cp.text" -}}
        {{ range .Alerts }}
            *Alert:* {{ .Annotations.message}}
            *Details:*
            {{ range .Labels.SortedPairs }} - *{{ .Name }}:* `{{ .Value }}`
            {{ end }}
          {{ end }}
      {{- end }}

      {{ define "__alert_silence_link" -}}
        {{ .ExternalURL }}/#/silences/new?filter=%7B
        {{- range .CommonLabels.SortedPairs -}}
          {{- if ne .Name "alertname" -}}
            {{- .Name }}%3D"{{- .Value -}}"%2C%20
          {{- end -}}
        {{- end -}}
          alertname%3D"{{ .CommonLabels.alertname }}"%7D
      {{- end }}

      {{ define "__alert_severity_prefix" -}}
          {{ if ne .Status "firing" -}}
          :white_check_mark:
          {{- else if eq .Labels.severity "critical" -}}
          :fire:
          {{- else if eq .Labels.severity "warning" -}}
          :warning:
          {{- else -}}
          :question:
          {{- end }}
      {{- end }}

      {{ define "__alert_severity_prefix_title" -}}
          {{ if ne .Status "firing" -}}
          :white_check_mark:
          {{- else if eq .CommonLabels.severity "critical" -}}
          :fire:
          {{- else if eq .CommonLabels.severity "warning" -}}
          :warning:
          {{- else if eq .CommonLabels.severity "info" -}}
          :information_source:
          {{- else if eq .CommonLabels.status_icon "information" -}}
          :information_source:
          {{- else -}}
          :question:
          {{- end }}
      {{- end }}

      {{ define "slack.color" -}}
        {{ if eq .Status "firing" -}}
          {{ if eq .CommonLabels.severity "warning" -}}
            warning
          {{- else if eq .CommonLabels.severity "critical" -}}
            danger
          {{- else -}}
            #439FE0
          {{- end -}}
        {{ else -}}
          good
          {{- end }}
      {{- end }}

  alertmanagerSpec:
    logLevel: info
    image:
      registry: quay.io
      repository: prometheus/alertmanager
      tag: v0.25.0
    retention: 120h

    securityContext:
      runAsGroup: 2000
      runAsNonRoot: true
      runAsUser: 1000
      fsGroup: 2000

    externalUrl: "http://${ monitoring_ingress }/alertmanager/"
    routePrefix: "/alertmanager"

grafana:
  enabled: true
  defaultDashboardsEnabled: true

  securityContext:
    fsGroup: 472
    runAsUser: 472
    runAsGroup: 472

  adminPassword: "${grafana_password}"

  persistence:
    enabled: false
    type: statefulset
    storageClassName: "" #gp2
    accessModes:
    - ReadWriteOnce
    size: 3Gi
    finalizers:
    - kubernetes.io/pvc-protection

  extraSecretMounts:
    - name: es-certs
      mountPath: /elastic/certs/
      secretName: elasticsearch-master-certs
      readOnly: true
      projected:
        defaultMode: 420


  ingress:
    enabled: false
    annotations:
      kubernetes.io/ingress.class: istio
      cert-manager.io/cluster-issuer: vault-cert-issuer #letsencrypt-${environment}
      kubernetes.io/tls-acme: "true"
      alb.ingress.kubernetes.io/group.name: "devops"
      alb.ingress.kubernetes.io/scheme: internet-facing
      external-dns.alpha.kubernetes.io/hostname: monitoring.devops.cliniciannexus.com
    hosts:
    - "${ monitoring_ingress }"
    path: /
    tls:
      - secretName: grafana-cert
        hosts:
        - "${ monitoring_ingress }"

  sidecar:
    image:
      repository: quay.io/kiwigrid/k8s-sidecar
    alerts:
      enabled: true
      label: grafana_alert
      labelValue: ""
      searchNamespace: ALL
    dashboards:
      enabled: true
      label: grafana_dashboard
      labelValue: ""
      searchNamespace: ALL
    datasources:
      enabled: true
      defaultDatasourceEnabled: true
      label: grafana_datasource
      labelValue: ""
      isDefaultDatasource: true
      uid: prometheus

  additionalDataSources:
    - name: Alertmanager
      type: "alertmanager"
      url: "http://alertmanager-operated.${namespace}:9093"
      version: 1
      access: proxy
      isDefault: false
      editable: true
      jsonData:
        implementation: prometheus
        handleGrafanaManagedAlerts: true

    - name: CloudWatch_local
      type: cloudwatch
      isDefault: false
      access: proxy
      editable: true
      jsonData:
        authType: default
        defaultRegion: ${region}
        assumeRoleArn: ${local_grafana_role}

    - name: CloudWatch_infra_prod
      type: cloudwatch
      isDefault: false
      access: proxy
      editable: true
      jsonData:
        authType: default
        defaultRegion: ${region}
        assumeRoleArn: ${infra_prod_grafana_role}

    - name: sc-elasticsearch-mpt
      type: elasticsearch
      editable: true
      access: proxy
      database: mpt*
      url: https://elasticsearch-master:9200
      basicAuth: true
      basicAuthUser: elastic
      jsonData:
        timeField: "@timestamp"
        tlsAuth: true
        tlsAuthWithCACert: true
        withCredentials: true
      secureJsonData:
        basicAuthPassword: "${es_master_password}"
        tlsCACert: $__file{/elastic/certs/ca.crt}
        tlsClientCert: $__file{/elastic/certs/tls.crt}
        tlsClientKey: $__file{/elastic/certs/tls.key}

    - name: sc-influxdb
      editable: true
      type: influxdb
      access: proxy
      user: ${influxdb_user}
      url: http://sc-influxdb-influxdb2
      jsonData:
        version: Flux
        organization: ${influxdb_organization}
        defaultBucket: ${influxdb_bucket}
        tlsSkipVerify: true
      secureJsonData:
        token: ${influxdb_token}
        password: ${influxdb_password}

    - name: Thanos
      type: prometheus
      url: "http://thanos-query-frontend.${namespace}:9090"
      isDefault: false
      access: proxy
      editable: true
      version: 1
      jsonData:
      tlsSkipVerify: true
      timeInterval: "5s"
      uid: thanos

  grafana.ini:
    check_for_updates: false
    reporting_enabled: false
    server:
      root_url: "https://${ monitoring_ingress }"
    security:
      disable_gravatar: true
      admin_email: devops@clinciannexus.com
    dashboards:
      min_refresh_interval: 60s
    auth.github:
      enabled: true
      allow_sign_up: true
      auto_login: false
      client_id: ${ github_oauth_client_id }
      client_secret: ${ github_oauth_client_secret }
      scopes: user:email,read:org
      auth_url: https://github.com/login/oauth/authorize
      token_url: https://github.com/login/oauth/access_token
      api_url: https://api.github.com/user
      team_ids: 7138394,7156544,7156987
      allowed_organizations: clinician-nexus
      role_attribute_path: contains(groups[*], '@clinician-nexus/devops') && 'Admin' || 'Viewer'
      allow_assign_grafana_admin: true
      skip_org_role_sync: false


prometheusOperator:
  enabled: true
  namespaces: {}
  resources:
  limits:
    cpu: 200m
    memory: 200Mi
  requests:
    cpu: 100m
    memory: 100Mi
  patch:
    enabled: true
    image:
      registry: registry.k8s.io
      repository: ingress-nginx/kube-webhook-certgen
      tag: controller-v1.6.4
      sha: ""
      pullPolicy: IfNotPresent
      securityContext:
        runAsGroup: 2000
        runAsNonRoot: true
        runAsUser: 2000
      certManager:
        enabled: true
  admissionWebhooks:
    patch:
      podAnnotations:
        sidecar.istio.io/inject: "false"

prometheus:
  enabled: true
  ## additionalServiceMonitors:
    ## - name: cortex-health-monitor
      ## endpoints:
      ## - path: /metrics
        ## port: http-metrics
      ## namespaceSelector:
        ## matchNames:
        ## - cortex
      ## selector:
        ## matchLabels:
          ## app.kuberntes.io/name: cortex

  ingress:
    enabled: false
    ingressClassName: ""
    annotations:
      kubernetes.io/ingress.class: istio
      kubernetes.io/tls-acme: "true"
      cert-manager.io/cluster-issuer: vault-cert-issuer #letsencrypt-${environment}
      alb.ingress.kubernetes.io/group.name: "devops"
      alb.ingress.kubernetes.io/scheme: internet-facing
      external-dns.alpha.kubernetes.io/hostname: monitoring.devops.cliniciannexus.com
    hosts:
      - "${ monitoring_ingress }"
    tls:
    - secretName: prometheus-cert
      hosts:
      - "${ monitoring_ingress }"
    paths:
      - /prom
      
  thanosService:
    enabled: true
    annotations: {}
    labels: {}
    externalTrafficPolicy: Cluster
    type: ClusterIP

  prometheusSpec:
    serviceMonitorSelector: {}
    externalLabels:
      environment: ${environment}

    ## remoteWrite:
    ## - url: http://cortex-distributor.cortex.svc:8080/api/prom/push
      ## headers:
        ## X-Scope-OrgID: internal-prometheus

    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: "" #gp2
          accessModes: 
          - ReadWriteOnce
          resources:
            requests:
              storage: 5Gi

    %{ if enable_thanos_sidecar == true ~}
    thanos:
      baseImage: quay.io/thanos/thanos
      objectStorageConfig:
        key: thanos.yaml
        name: thanos-objstore-config 
      query:
        enabled: true
    %{ endif ~}

    externalUrl: "http://${ monitoring_ingress }/${ prometheus_release_name }/"
    routePrefix: "/prometheus"

  env:
    GF_ANALYTICS_REPORTING_ENABLED: "false"
    GF_AUTH_DISABLE_LOGIN_FORM: "true"
    GF_USERS_ALLOW_SIGN_UP: "false"
    GF_INSTALL_PLUGINS: "camptocamp-prometheus-alertmanager-datasource"
    GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS: "camptocamp-prometheus-alertmanager-datasource"
    GF_USERS_AUTO_ASSIGN_ORG_ROLE: "Viewer"
    GF_USERS_VIEWERS_CAN_EDIT: "true"
    GF_SMTP_ENABLED: "false"
    GF_FEATURE_TOGGLES_ENABLE: "ngalert"


## Configuration for thanosRuler
## ref: https://thanos.io/tip/components/rule.md/
##
thanosRuler:
  enabled: true
  objectStorageConfig:
    key: thanos.yaml
    name: thanos-objstore-config 

  ## Annotations for ThanosRuler
  ##
  annotations: {}
  serviceAccount:
    create: true

  service:
    annotations: {}
    labels: {}
    clusterIP: ""
    port: 10902
    targetPort: 10902
    externalTrafficPolicy: Cluster
    type: ClusterIP

  serviceMonitor:
    selfMonitor: true
    sampleLimit: 0
    targetLimit: 0
    labelLimit: 0
    labelNameLengthLimit: 0
    labelValueLengthLimit: 0
    proxyUrl: ""

  thanosRulerSpec:
    image:
      registry: quay.io
      repository: thanos/thanos
      sha: ""
    ruleSelectorNilUsesHelmValues: true
    logFormat: logfmt
    logLevel: info
    replicas: 1
    retention: 24h

    externalPrefix:
    routePrefix: /
    paused: false
    podAntiAffinityTopologyKey: kubernetes.io/hostname
    securityContext:
      runAsGroup: 2000
      runAsNonRoot: true
      runAsUser: 1000
      fsGroup: 2000
    listenLocal: false
    portName: "web"
cleanPrometheusOperatorObjectNames: false

kubeScheduler:
  enabled: true
  service:
    enabled: true
    selector:
      component: kube-scheduler

kubeEtcd:
  enabled: true
  service:
    enabled: true
    port: 2381
    targetPort: 2381
    selector:
      component: etcd

kubeControllerManager:
  enabled: true
  service:
    selector:
      component: kube-controller-manager
  insecureSkipVerify: null

metrics:
  enabled: true
  serviceMonitor:
    enabled: true
  podMonitor:
    enabled: true

nodeExporter:
  enabled: true