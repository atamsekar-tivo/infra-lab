variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "GitHub Organization or User"
  type        = string
  default     = "atamsekar-tivo"
}

variable "repo_name" {
  description = "GitHub Repository Name"
  type        = string
  default     = "infra-lab"
}
