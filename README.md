# Infra Lab

A self-contained, optional, pluggable SRE/DevOps learning environment using Terraform + Kind.

## Directory Structure

- `terraform/`: Infrastructure as Code definitions.
  - `modules/`: Pluggable components (Kind, etc.).
  - `main.tf`: Entry point for the infrastructure.
- `apps/`: Sample applications for GitOps.
- `scripts/`: Helper scripts.

## Getting Started

1.  Navigate to `terraform/`:
    ```bash
    cd terraform
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Apply the configuration to create the Kind cluster:
    ```bash
    terraform apply
    ```

## Modules

- **Kind**: Creates a local Kubernetes cluster using Docker containers. Includes Ingress support.
