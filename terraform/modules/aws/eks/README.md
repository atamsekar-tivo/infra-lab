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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the EKS cluster | `string` | n/a | yes |
| `cluster_version` | Kubernetes version for the cluster | `string` | `"1.31"` | no |
| `tags` | A map of tags to add to all resources | `map(string)` | `{}` | no |
| `create_vpc` | Whether to create a new VPC for the cluster | `bool` | `false` | no |
| `vpc_id` | ID of the existing VPC (required if create_vpc is false) | `string` | `null` | no |
| `subnet_ids` | List of subnet IDs (required if create_vpc is false) | `list(string)` | `[]` | no |
| `vpc_cidr` | CIDR block for the new VPC (if create_vpc is true) | `string` | `"10.0.0.0/16"` | no |
| `public_subnets` | List of public subnet CIDRs for the new VPC | `list(string)` | `["10.0.101.0/24", ...]` | no |
| `private_subnets` | List of private subnet CIDRs for the new VPC | `list(string)` | `["10.0.1.0/24", ...]` | no |
| `enable_irsa` | Enable IRSA (IAM Roles for Service Accounts) | `bool` | `true` | no |
| `cluster_endpoint_private_access` | Enable/disable private API server endpoint | `bool` | `true` | no |
| `cluster_endpoint_public_access` | Enable/disable public API server endpoint | `bool` | `true` | no |
| `cluster_endpoint_public_access_cidrs` | List of CIDRs which can access the public API server | `list(string)` | `["0.0.0.0/0"]` | no |
| `cloudwatch_log_types` | List of control plane logging to enable | `list(string)` | `["api", "audit", ...]` | no |
| `cloudwatch_log_retention_in_days` | Number of days to retain log events | `number` | `7` | no |
| `node_groups` | Map of node group configurations | `map(object)` | `{}` | no |
| `cluster_addons` | Map of cluster addon configurations | `map(object)` | `{}` | no |
