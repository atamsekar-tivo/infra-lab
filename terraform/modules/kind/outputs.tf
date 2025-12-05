output "kubeconfig" {
  value     = kind_cluster.cluster.kubeconfig
  sensitive = true
}

output "cluster_name" {
  value = kind_cluster.cluster.name
}

output "endpoint" {
  value = kind_cluster.cluster.endpoint
}

output "client_certificate" {
  value     = kind_cluster.cluster.client_certificate
  sensitive = true
}

output "client_key" {
  value     = kind_cluster.cluster.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = kind_cluster.cluster.cluster_ca_certificate
  sensitive = true
}
