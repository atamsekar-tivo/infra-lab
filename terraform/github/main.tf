provider "github" {
  token = var.github_token
  owner = var.owner
}

resource "github_repository" "main" {
  name        = var.repo_name
  description = "Infrastructure Lab"
  visibility  = "public"

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_branch_protection" "master" {
  repository_id = github_repository.main.node_id
  pattern       = "master"

  enforce_admins = true

  required_status_checks {
    strict   = true
    contexts = [] # Add CI contexts here when available
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
    required_approving_review_count = 1
  }

  allows_deletions = false
}
