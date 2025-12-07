variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.31"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_vpc" {
  description = "Whether to create a new VPC for the cluster"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the existing VPC (required if create_vpc is false)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the cluster (required if create_vpc is false)"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "CIDR block for the new VPC (if create_vpc is true)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "List of private subnet CIDRs for the new VPC (if create_vpc is true)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs for the new VPC (if create_vpc is true)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_irsa" {
  description = "Enable IRSA (IAM Roles for Service Accounts)"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cloudwatch_log_types" {
  description = "A list of the desired control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudwatch_log_retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 7
}

variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
    capacity_type  = optional(string, "ON_DEMAND") # OR SPOT
    disk_size      = optional(number, 20)
    ami_type       = optional(string, "AL2_x86_64")
    labels         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = {}
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations"
  type = map(object({
    resolve_conflicts = optional(string, "OVERWRITE")
    version           = optional(string)
  }))
  default = {}
}
