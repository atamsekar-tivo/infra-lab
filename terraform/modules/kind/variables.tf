variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
}

variable "node_image" {
  description = "Docker image for Kind nodes"
  type        = string
  default     = "kindest/node:v1.27.3"
  validation {
    condition     = can(regex("^kindest/node:v[0-9]+\\.[0-9]+\\.[0-9]+(-[a-zA-Z0-9.-]+)?$", var.node_image))
    error_message = "The node_image must be in the format 'kindest/node:v<MAJOR>.<MINOR>.<PATCH>' (e.g., kindest/node:v1.27.3)."
  }
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
    condition     = var.worker_count >= 0
    error_message = "worker_count must be a non-negative number."
  }
  validation {
    condition     = var.worker_count >= 0
    error_message = "The worker_count must be at least 0."
  }
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file. **Warning:** If you set this to `~/.kube/config`, it may overwrite your existing kubeconfig and cause loss of access to other clusters. The default is a safer alternative."
  type        = string
  default     = "~/.kube/kind-config"
}
