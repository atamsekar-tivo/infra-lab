terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source = "../../modules/aws/eks"

  cluster_name    = "example-eks-cluster"
  cluster_version = "1.31"

  create_vpc = true
  vpc_cidr   = "10.0.0.0/16"

  node_groups = {
    spot_group = {
      desired_size   = 1
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      ami_type       = "AL2_x86_64"
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni    = {}
  }

  tags = {
    Example = "true"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}
