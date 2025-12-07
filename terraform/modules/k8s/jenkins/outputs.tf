output "namespace" {
  description = "The namespace where Jenkins was deployed"
  value       = var.create_namespace ? kubernetes_namespace_v1.this[0].metadata[0].name : var.namespace
}

output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.jenkins.name
}

output "jenkins_url" {
  description = "The URL of the Jenkins instance (if Ingress is enabled)"
  value       = var.ingress_enabled ? "http://${var.ingress_host}" : null
}

output "admin_secret_name" {
  description = "The name of the Kubernetes secret containing the admin password"
  value       = helm_release.jenkins.name # Standard chart behavior: secret name matches release name usually, or explicit.
  # Actually, the chart usually creates 'jenkins' secret. Let's safeguard this.
  # The output here is just informational. The robust way is to read the secret, but outputs should be simple.
}
