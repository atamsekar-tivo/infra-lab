output "namespace" {
  description = "The namespace where Jenkins was deployed"
  value       = local.namespace
}

output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.jenkins.name
}

output "jenkins_url" {
  description = "The URL of the Jenkins instance (if Ingress is enabled)"
  value       = var.ingress_enabled ? "${var.jenkins_url_protocol}://${var.ingress_host}" : null
}

output "admin_secret_name" {
  description = "The name of the Kubernetes secret containing the admin password"
  value       = helm_release.jenkins.name
}
