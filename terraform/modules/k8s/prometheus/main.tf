resource "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

locals {
  namespace = var.create_namespace ? kubernetes_namespace_v1.this[0].metadata[0].name : var.namespace
}

resource "helm_release" "prometheus" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.helm_chart_version
  namespace        = local.namespace
  create_namespace = false
  depends_on       = [kubernetes_namespace_v1.this]

  # Prometheus Configuration
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = var.retention_days
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = var.storage_class
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = var.prometheus_volume_size
  }

  set {
    name  = "prometheus.service.type"
    value = var.service_type
  }

  # Prometheus Ingress
  set {
    name  = "prometheus.ingress.enabled"
    value = var.prometheus_ingress_enabled
  }

  dynamic "set" {
    for_each = var.prometheus_ingress_enabled ? [1] : []
    content {
      name  = "prometheus.ingress.ingressClassName"
      value = var.ingress_class_name
    }
  }

  dynamic "set" {
    for_each = var.prometheus_ingress_enabled ? [1] : []
    content {
      name  = "prometheus.ingress.hosts[0]"
      value = var.prometheus_ingress_host
    }
  }

  # Grafana Configuration
  set {
    name  = "grafana.enabled"
    value = var.grafana_enabled
  }

  dynamic "set" {
    for_each = var.grafana_enabled && var.grafana_admin_password != null ? [1] : []
    content {
      name  = "grafana.adminPassword"
      value = var.grafana_admin_password
    }
  }

  dynamic "set" {
    for_each = var.grafana_enabled ? [1] : []
    content {
      name  = "grafana.persistence.enabled"
      value = "true"
    }
  }

  dynamic "set" {
    for_each = var.grafana_enabled ? [1] : []
    content {
      name  = "grafana.persistence.storageClassName"
      value = var.storage_class
    }
  }

  dynamic "set" {
    for_each = var.grafana_enabled ? [1] : []
    content {
      name  = "grafana.persistence.size"
      value = var.grafana_volume_size
    }
  }

  # Grafana Ingress
  dynamic "set" {
    for_each = var.grafana_enabled ? [1] : []
    content {
      name  = "grafana.ingress.enabled"
      value = var.grafana_ingress_enabled
    }
  }

  dynamic "set" {
    for_each = var.grafana_enabled && var.grafana_ingress_enabled ? [1] : []
    content {
      name  = "grafana.ingress.ingressClassName"
      value = var.ingress_class_name
    }
  }

  dynamic "set" {
    for_each = var.grafana_enabled && var.grafana_ingress_enabled ? [1] : []
    content {
      name  = "grafana.ingress.hosts[0]"
      value = var.grafana_ingress_host
    }
  }

  # Alertmanager Configuration
  set {
    name  = "alertmanager.enabled"
    value = var.alertmanager_enabled
  }

  dynamic "set" {
    for_each = var.alertmanager_enabled ? [1] : []
    content {
      name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName"
      value = var.storage_class
    }
  }

  dynamic "set" {
    for_each = var.alertmanager_enabled ? [1] : []
    content {
      name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage"
      value = var.alertmanager_volume_size
    }
  }

  # Allow passing arbitrary values
  dynamic "set" {
    for_each = var.additional_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
