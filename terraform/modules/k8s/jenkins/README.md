# Jenkins Terraform Module

A production-ready Terraform module to deploy Jenkins on Kubernetes using the official Helm chart.

## Features

- **Helm-based Deployment**: Uses `charts.jenkins.io`.
- **Flexible Storage**: Configurable `storage_class` (supports Kind `standard` or EKS `gp3`).
- **Ingress Support**: Optional Ingress resource generation.
- **Secure Defaults**: Namespace isolation and secret management.
- **Service Types**: Supports ClusterIP, NodePort or LoadBalancer.

## Usage

### Basic Example (Kind)

```hcl
module "jenkins" {
  source = "../../modules/k8s/jenkins"

  namespace     = "jenkins-system"
  storage_class = "standard" # Kind default
}
```

### EKS Example with Ingress

```hcl
module "jenkins" {
  source = "../../modules/k8s/jenkins"

  namespace        = "ci-cd"
  storage_class    = "gp3"
  ingress_enabled  = true
  ingress_host     = "jenkins.example.com"
  
  # Secure Admin Password
  admin_password   = "SuperSecret123!" 
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `namespace` | Kubernetes namespace | `string` | `"jenkins"` | no |
| `create_namespace` | Create the namespace | `bool` | `true` | no |
| `helm_chart_version` | Jenkins Chart Version | `string` | `"5.1.5"` | no |
| `storage_class` | Storage Class Name | `string` | `"standard"` | no |
| `admin_password` | Admin password | `string` | `null` (auto-generated) | no |
| `ingress_enabled` | Enable Ingress | `bool` | `false` | no |
| `ingress_host` | Ingress Hostname | `string` | `"jenkins.local"` | no |
| `service_type` | K8s Service Type | `string` | `"ClusterIP"` | no |
