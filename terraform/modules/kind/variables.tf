variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
}

variable "node_image" {
  description = "Docker image for Kind nodes"
  type        = string
  validation {
    condition     = can(regex("^kindest/node:", var.node_image))
    error_message = "The node_image must start with 'kindest/node:'."
  }
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
  validation {
    condition     = var.worker_count >= 1
    error_message = "The worker_count must be at least 1."
  }
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}
