<!-- # hello-azure-v2
📋 Run Unique on Microsoft Azure with a simple, secure, and fully automated setup triggered on every release. -->

# Hello Azure Repository

This repository contains a complete Hello Azure infrastructure deployment solution using Terraform, designed for automated and manual deployment workflows.
It also includes a setup of ArgoCD used for deploying workloads to the AKS cluster.

## 🏗️ Infrastructure Overview

- **01_bootstrap**: Bootstrap the tenant and set up the remote Terraform state storage.
- **02_infrastructure**: Deploy the infrastructure.
- **03_applications**: Bootstrap ArgoCD and deploy the workloads to the AKS cluster.

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and logged in (`az login`)
- Terraform 1.5+ installed


**Ready to get started?** Begin with the [Configuration Guide](/01_bootstrap/README.md) to understand how to create remote Terraform state storage, then follow the guides in 02_infrastructure and 03_applications.