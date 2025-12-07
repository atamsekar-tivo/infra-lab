resource "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.helm_chart_version
  namespace  = var.create_namespace ? kubernetes_namespace_v1.this[0].metadata[0].name : var.namespace

  # Set admin password securely
  dynamic "set" {
    for_each = var.admin_password != null ? [1] : []
    content {
      name  = "controller.adminPassword"
      value = var.admin_password
    }
  }

  # Configurable Service Type
  set {
    name  = "controller.serviceType"
    value = var.service_type
  }

  # Ingress Configuration
  set {
    name  = "controller.ingress.enabled"
    value = var.ingress_enabled
  }

  set {
    name  = "controller.ingress.hostName"
    value = var.ingress_host
  }

  set {
    name  = "controller.ingress.ingressClassName"
    value = var.ingress_class_name
  }

  # Persistence Configuration
  set {
    name  = "persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "persistence.size"
    value = var.volume_size
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
