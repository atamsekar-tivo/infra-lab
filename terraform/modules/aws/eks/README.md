# AWS EKS Terraform Module

A clean, minimal, production-grade Terraform module for provisioning an Amazon EKS cluster.

## Features

- Configurable EKS Cluster (Control Plane)
- Managed Node Groups with support for Spot Instances (Cost Optimized)
- Optional VPC creation (or bring your own VPC)
- IRSA (IAM Roles for Service Accounts) OIDC Provider enabled
- Basic AWS Managed Add-ons support
- CloudWatch Logging with configurable retention
- Secure defaults (Encrypted secrets, private/public endpoint access)

## Usage

### Basic Example (Cost Optimized)

```hcl
module "eks" {
  source = "../../modules/aws/eks"

  cluster_name    = "my-lab-cluster"
  cluster_version = "1.31"

  # Cost Optimization: Use existing VPC if possible, or create simple one.
  create_vpc      = true
  vpc_cidr        = "10.0.0.0/16"
  
  # Basic Node Group (Spot Instances for cost savings)
  node_groups = {
    general = {
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      disk_size      = 20
    }
  }

  # Essential Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cluster_name` | Name of the EKS cluster | `string` | n/a |
| `cluster_version` | Kubernetes version | `string` | `1.31` |
| `create_vpc` | Create a new VPC | `bool` | `false` |
| `node_groups` | Map of node group configurations | `map(object)` | `{}` |
| `cluster_addons` | Map of addon configurations | `map(object)` | `{}` |
| `enable_irsa` | Enable OIDC provider | `bool` | `true` |

(See `variables.tf` for full list)
