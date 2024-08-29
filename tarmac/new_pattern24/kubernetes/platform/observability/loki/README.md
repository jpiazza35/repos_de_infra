### LOKI
Grafana Loki is a log aggregation system that is part of Grafana, an open-source web application that provides charts, graphs, and alerts.

Loki is a log aggregation system designed to store and query logs from all your applications and infrastructure. Loki is optimized for Kubernetes, and is designed to be cost-effective and easy to operate. Loki is like Prometheus, but for logsLoki differs from Prometheus by focussing on logs instead of metrics, and delivering logs via push, instead of pull.

Here are some features of Grafana Loki: 
- Label-based indexing: Loki focuses on label-based indexing and avoids full-text indexing.
- Metadata indexing: Loki only indexes metadata about your logs, such as labels.
- Scalability: Loki is horizontally scalable and capable of handling petabytes of log data.
- Integration: Loki integrates seamlessly with Prometheus and Grafana.
- Cost-effectiveness: Loki is designed to be very cost effective

### Loki Components
Loki comprises of the following components:
- Grafana Agent: It is the agent, responsible for gathering logs and sending them to Loki.
- Loki: It is the main server, responsible for storing logs and processing queries.
- Grafana: It is the UI for visualizing logs and metrics.
