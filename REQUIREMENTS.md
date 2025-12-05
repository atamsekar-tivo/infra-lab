# Deployment Requirements

This document outlines the prerequisites for deploying the **Infra Lab** environment on macOS or Linux.

## Operating System
- **macOS**: 12.0 (Monterey) or newer (Intel or Apple Silicon).
- **Linux**: Any modern distribution (Ubuntu 20.04+, Fedora 36+, etc.) with systemd.

## Core Dependencies

### 1. Docker Engine
The foundation of the environment. Kind (Kubernetes in Docker) runs cluster nodes as Docker containers.
- **Requirement**: Docker Engine 20.10.0 or newer.
- **Installation**:
  - **macOS**: [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/) or [OrbStack](https://orbstack.dev/) (lighter alternative).
  - **Linux**: [Docker Engine](https://docs.docker.com/engine/install/).
- **Verify**:
  ```bash
  docker version
  ```
  *Ensure the Docker daemon is running.*

### 2. Terraform
Used for Infrastructure as Code (IaC) to provision the Kind cluster and base configurations.
- **Requirement**: Terraform v1.0.0 or newer.
- **Installation**: [Install Terraform](https://developer.hashicorp.com/terraform/install).
- **Verify**:
  ```bash
  terraform version
  ```

### 3. Git
Required to clone the repository.
- **Verify**:
  ```bash
  git --version
  ```

## Recommended Tools

### 1. kubectl
Command-line tool for interacting with the Kubernetes cluster.
- **Installation**: [Install kubectl](https://kubernetes.io/docs/tasks/tools/).
- **Verify**:
  ```bash
  kubectl version --client
  ```

### 2. GitHub CLI (gh)
Useful for interacting with GitHub repositories and authentication.
- **Installation**: [Install gh](https://cli.github.com/).

## Hardware Resources
Since this environment runs a Kubernetes cluster locally, ensure your machine has sufficient resources:
- **RAM**: Minimum 8GB, Recommended 16GB+.
- **CPU**: Minimum 4 cores.
- **Disk**: At least 20GB of free space for Docker images and volumes.
