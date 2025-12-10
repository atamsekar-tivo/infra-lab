output "namespace" {
  description = "Namespace where Prometheus is deployed"
  value       = local.namespace
}

output "helm_release_name" {
  description = "Name of the Helm release"
  value       = helm_release.prometheus.name
}

output "prometheus_service_name" {
  description = "Name of the Prometheus service"
  value       = "kube-prometheus-stack-prometheus"
}

output "prometheus_url" {
  description = "Internal URL to access Prometheus"
  value       = "http://kube-prometheus-stack-prometheus.${local.namespace}.svc.cluster.local:9090"
}

output "grafana_service_name" {
  description = "Name of the Grafana service (if enabled)"
  value       = var.grafana_enabled ? "kube-prometheus-stack-grafana" : null
}

output "grafana_url" {
  description = "Internal URL to access Grafana (if enabled)"
  value       = var.grafana_enabled ? "http://kube-prometheus-stack-grafana.${local.namespace}.svc.cluster.local:80" : null
}

output "alertmanager_service_name" {
  description = "Name of the Alertmanager service (if enabled)"
  value       = var.alertmanager_enabled ? "kube-prometheus-stack-alertmanager" : null
}

output "alertmanager_url" {
  description = "Internal URL to access Alertmanager (if enabled)"
  value       = var.alertmanager_enabled ? "http://kube-prometheus-stack-alertmanager.${local.namespace}.svc.cluster.local:9093" : null
}
