# Prometheus Terraform Module

A production-ready Terraform module to deploy Prometheus for Kubernetes cluster metrics collection using the official `kube-prometheus-stack` Helm chart.

## Features

- **Comprehensive Monitoring Stack**: Deploys Prometheus, Grafana, Alertmanager, Node Exporter, and Kube-State-Metrics
- **Helm-based Deployment**: Uses official `prometheus-community` charts
- **Flexible Storage**: Configurable `storage_class` (supports Kind `standard` or EKS `gp3`)
- **Ingress Support**: Optional Ingress resources for Prometheus and Grafana
- **Secure Defaults**: Namespace isolation and secret management
- **Configurable Components**: Enable/disable Grafana and Alertmanager as needed
- **Metrics Retention**: Configurable retention period for time-series data

## What Gets Deployed

The `kube-prometheus-stack` includes:

- **Prometheus Server**: Collects and stores metrics from Kubernetes cluster
- **Grafana**: Pre-configured dashboards for cluster visualization (optional)
- **Alertmanager**: Handles alerts from Prometheus (optional)
- **Node Exporter**: Collects host-level metrics from nodes
- **Kube-State-Metrics**: Generates metrics about Kubernetes object states
- **Prometheus Operator**: Manages Prometheus instances and configurations

## Usage

### Basic Example (Kind)

```hcl
module "prometheus" {
  source = "../../modules/k8s/prometheus"

  namespace     = "monitoring"
  storage_class = "standard" # Kind default
}
```

### Minimal Prometheus-Only Deployment

```hcl
module "prometheus" {
  source = "../../modules/k8s/prometheus"

  namespace            = "monitoring"
  grafana_enabled      = false
  alertmanager_enabled = false
}
```

### EKS Example with Ingress

```hcl
module "prometheus" {
  source = "../../modules/k8s/prometheus"

  namespace     = "monitoring"
  storage_class = "gp3"

  # Prometheus Configuration
  retention_days         = "30d"
  prometheus_volume_size = "50Gi"

  # Prometheus Ingress
  prometheus_ingress_enabled = true
  prometheus_ingress_host    = "prometheus.example.com"

  # Grafana Configuration
  grafana_enabled        = true
  grafana_admin_password = var.grafana_password # Use a secure variable
  grafana_volume_size    = "10Gi"

  # Grafana Ingress
  grafana_ingress_enabled = true
  grafana_ingress_host    = "grafana.example.com"

  ingress_class_name = "alb"
}
```

### Advanced Configuration

```hcl
module "prometheus" {
  source = "../../modules/k8s/prometheus"

  namespace              = "observability"
  helm_chart_version     = "67.4.0"
  storage_class          = "gp3"
  service_type           = "LoadBalancer"

  # Prometheus settings
  retention_days         = "90d"
  prometheus_volume_size = "100Gi"

  # Custom Helm values
  additional_set_values = [
    {
      name  = "prometheus.prometheusSpec.scrapeInterval"
      value = "30s"
    },
    {
      name  = "prometheus.prometheusSpec.evaluationInterval"
      value = "30s"
    }
  ]
}
```

## Accessing the Services

### Port Forwarding (Local Development)

**Prometheus:**
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
# Access at http://localhost:9090
```

**Grafana:**
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
# Access at http://localhost:3000
# Default credentials: admin / prom-operator (unless custom password set)
```

**Alertmanager:**
```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-alertmanager 9093:9093
# Access at http://localhost:9093
```

### Via Ingress

If ingress is enabled, access services at the configured hostnames:
- Prometheus: `http://prometheus.example.com`
- Grafana: `http://grafana.example.com`

## Default Metrics Collection

The stack automatically collects metrics from:

- **Kubernetes API Server**: Cluster-level metrics
- **Kubelet**: Node and pod metrics
- **cAdvisor**: Container metrics
- **Node Exporter**: Host-level metrics (CPU, memory, disk, network)
- **Kube-State-Metrics**: Kubernetes object states (deployments, pods, services, etc.)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `namespace` | Kubernetes namespace | `string` | `"monitoring"` | no |
| `create_namespace` | Create the namespace | `bool` | `true` | no |
| `helm_chart_version` | kube-prometheus-stack Chart Version | `string` | `"67.4.0"` | no |
| `retention_days` | Metrics retention period | `string` | `"15d"` | no |
| `storage_class` | Storage Class Name | `string` | `"standard"` | no |
| `prometheus_volume_size` | Prometheus PVC size | `string` | `"10Gi"` | no |
| `service_type` | K8s Service Type | `string` | `"ClusterIP"` | no |
| `grafana_enabled` | Enable Grafana | `bool` | `true` | no |
| `grafana_admin_password` | Grafana admin password | `string` | `null` (auto-generated) | no |
| `grafana_volume_size` | Grafana PVC size | `string` | `"5Gi"` | no |
| `alertmanager_enabled` | Enable Alertmanager | `bool` | `true` | no |
| `alertmanager_volume_size` | Alertmanager PVC size | `string` | `"2Gi"` | no |
| `prometheus_ingress_enabled` | Enable Prometheus Ingress | `bool` | `false` | no |
| `prometheus_ingress_host` | Prometheus Ingress Hostname | `string` | `"prometheus.local"` | no |
| `grafana_ingress_enabled` | Enable Grafana Ingress | `bool` | `false` | no |
| `grafana_ingress_host` | Grafana Ingress Hostname | `string` | `"grafana.local"` | no |
| `ingress_class_name` | Ingress Class Name | `string` | `"nginx"` | no |
| `additional_set_values` | Additional Helm values | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `namespace` | Deployed namespace |
| `helm_release_name` | Helm release name |
| `prometheus_service_name` | Prometheus service name |
| `prometheus_url` | Internal Prometheus URL |
| `grafana_service_name` | Grafana service name (if enabled) |
| `grafana_url` | Internal Grafana URL (if enabled) |
| `alertmanager_service_name` | Alertmanager service name (if enabled) |
| `alertmanager_url` | Internal Alertmanager URL (if enabled) |

## Notes

- **Storage**: Ensure the specified `storage_class` exists in your cluster
- **Ingress**: Requires an Ingress controller (e.g., nginx-ingress, AWS ALB) to be installed
- **Resources**: The full stack can be resource-intensive; consider resource limits for production
- **Grafana Password**: Retrieve auto-generated password with:
  ```bash
  kubectl get secret -n monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
  ```

## References

- [kube-prometheus-stack Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
