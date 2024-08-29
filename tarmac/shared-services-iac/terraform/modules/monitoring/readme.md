# Services deployed

## Monitoring

### ES cluster

The elasticsearch is deployed with a master, client and data nodes defined as roles in the config.
There are different indexs for specific data, like logs, metrics, etc.

It has it's passwords created outside the HELM chart to have control over it, save in Vault and as a TF secret.
The elasticsearch is configured with a persistent volume claim to store the data. This pvs are encrypted with the password so there are no

PVs names:
- elasticsearch-data-elasticsearch-data-0
- elasticsearch-master-elasticsearch-master-0


### Fluentd MPT configs

MPT logs are configured from a Fluentd DaemonSet that collects logs from all pods in the cluster and sends them to the elasticsearch in a specific index.
The fluentd is a privileged pod that can read all the logs from the node host.

To add new apps to be monitored by fluentd, add the code to the bottom of the fluentd.yml:

```
      <source>
        @type tail
        path /var/log/containers/*PATTERN-NAME-OF-APPS*.log
        pos_file fluentd-docker.pos
        read_from_head true
        tag RELEVANT-TAG.*
        <parse>
          @type multiline
          format_firstline /(?i)(?<regexpfiler1>.*\berror\b.*)/
          format1 /(?<capture>(?:(?:.*\\n){0,10}.*)\z)/
        </parse>
      </source>

      <filter RELEVANT-TAG.**>
        @type kubernetes_metadata
      </filter>

      <match RELEVANT-TAG.**>
        @type elasticsearch
        host elasticsearch-master
        port 9200
        scheme https
        user elastic
        password ELASTIC_PASSWORD_TO_REPLACE
        ssl_verify true
        ssl_version TLSv1_3
        ca_file /elastic/certs/ca.crt
        client_cert /elastic/certs/tls.crt
        client_key /elastic/certs/tls.key
        logstash_format true
        logstash_prefix RELEVANT-TAG
        logstash_dateformat %Y%m%d
        include_timestamp true

        <buffer>
          @type file
          path /opt/bitnami/fluentd/logs/buffers/logs.buffer
          flush_thread_count 2
          flush_interval 4s
        </buffer>
      </match>
```

There are two placeholders there that need to be replaced:
- PATTERN-NAME-OF-APPS
- RELEVANT-TAG

The PATTERN-NAME-OF-APPS is the name of the apps that you want to monitor.
The RELEVANT-TAG is the tag that will be used to identify the logs in the elasticsearch index.

Afterwards its required to create a dashboard and import it to the Grafana.

### Influxdb

Deployed as a single node, version2, gives real-time insights from any time series data.
Used for URL monitoring in combination with Telegraf.
Password also created outside of the HELM to have a simple way of sharing it with the Telegraf pod, or any other required service.

The Influxdb has a PV for data:
- sc-influxdb-influxdb2

### Telegraf

Telegraf is a single pod running a plugin for each config.
It depends of the DB Influxdb2 to be deployed fist.

Telegraf uses the following plugins, configured in the telegraf.yml:

    inputs:
    - ping:
        name_override: "ping_url_monitoring"
        arguments: ["-i", "60.0", "-W", "5.0"]
        count: 3
        method: "native"
        urls:
            - "app.cliniciannexus.com"
            - "demo.cliniciannexus.com"

    outputs:
    - influxdb_v2:
        urls:
            - "http://sc-influxdb-influxdb2:80"
        token: ${influxdb_token}
        organization: ${influxdb_organization}
        bucket: ${influxdb_bucket}

To add new URLs to be monitored, modify the code to the bottom of the telegraf.yml:

```
    inputs:
    - ping:
        name_override: "ping_url_monitoring"
        arguments: ["-i", "60.0", "-W", "5.0"]
        count: 3
        method: "native"
        urls:
            - "app.cliniciannexus.com"
            - "demo.cliniciannexus.com"
            - "NEW-URL-TO-MONITOR"

```

Afterwards its required to update the URL monitoring dashboard. Best way is to do it in UI and export it as a JSON to be applied with Terraform.

### Grafana Prometheus

Grafana is deployed from Prometheus and is a subchart of the Prometheus chart.
All configurations like datasources, mounts of secrets and certificates for both prometheus and grafana are done using the prometheus_operator.yml.tpl file.

The dependency is as follows because it has datasouces from the DBs:
1- Elasticsearch cluster
2- InfluxDB
3- Prometheus

The Prometheus also has a PV for data:
- prometheus

The Grafana dashboards are built from the UI and then exported as a JSON.
The path of the JSON files is 'shared-services-iac/terraform/modules/monitoring/grafana/dashboards'

The dashboards are deployed using terraform, it applies the configmaps that target the JSON files and creates the dashboards in the Grafana.
The path of the configmap setup is 'shared-services-iac/terraform/modules/monitoring/dashboards.tf'

