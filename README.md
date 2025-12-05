# Infra Lab

A self-contained, optional, pluggable SRE/DevOps learning environment using Terraform + Kind.

## Directory Structure

- `terraform/`: Infrastructure as Code definitions.
  - `modules/`: Pluggable components (Kind, etc.).
  <!-- Entry point file (e.g., main.tf) not present; update as needed to reflect actual files. -->


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

## Example Configuration

Create a `main.tf` file in the `terraform/` directory with the following content to use the Kind module:

```hcl
module "kind" {
  source = "./modules/kind"
  # Add any required variables here, for example:
  # cluster_name = "infra-lab"
}
## Modules

- **Kind**: Creates a local Kubernetes cluster using Docker containers. Includes Ingress support.
