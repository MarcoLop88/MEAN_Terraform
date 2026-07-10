# MEAN_Terraform

Automated AWS infrastructure deployment for a **MEAN** stack application (MongoDB, Express, Angular, Node.js) using **Terraform** as the Infrastructure as Code (IaC) tool.

The project provisions a three-tier architecture with public and private subnets, an Application Load Balancer, EC2 instances for the Node.js application, an instance for MongoDB, and a NAT Gateway that allows private resources to reach the internet without being publicly exposed.

---
📖 **Spanish version:** [README.md](README.md)
## Table of Contents

- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Tool Installation](#tool-installation)
  - [Terraform](#terraform)
  - [AWS CLI v2](#aws-cli-v2)
- [Project Structure](#project-structure)
- [Usage](#usage)
  - [1. Initialize Terraform](#1-initialize-terraform)
  - [2. Validate the Configuration](#2-validate-the-configuration)
  - [3. Deploy the Infrastructure](#3-deploy-the-infrastructure)
  - [4. Destroy the Infrastructure](#4-destroy-the-infrastructure)
- [Outputs](#outputs)
- [Security Notes](#security-notes)
- [License](#license)

---

## Architecture

The infrastructure is organized into four independent, reusable modules:

| Module | Responsibility |
|---|---|
| `vpc` | Virtual network, public/private subnets, route tables, Internet Gateway, and NAT Gateway |
| `security` | Security groups for the ALB, Node.js instances, and MongoDB |
| `compute` | Node.js EC2 instances (private) and MongoDB instance (private) |
| `alb` | Application Load Balancer, listeners, and target groups to distribute HTTP traffic to the Node.js instances |

**Security design:** only the ALB is publicly reachable. The Node.js and MongoDB instances live in private subnets with no public IP, and reach the internet (for package updates) only through the NAT Gateway.

---

## Prerequisites

- AWS account with access credentials (Access Key ID / Secret Access Key)
- Windows 11 (instructions use PowerShell; on Linux/macOS the Terraform and AWS CLI commands are equivalent)
- Administrator permissions to modify environment variables

---

## Tool Installation

### Terraform

1. Download the official `terraform.exe` binary from [terraform.io/downloads](https://developer.hashicorp.com/terraform/downloads) and place it in `C:\Terraform`.
2. Permanently add the path to the user's environment variables:

   ```powershell
   [Environment]::SetEnvironmentVariable(
     "Path",
     [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Terraform",
     "User"
   )
   ```

3. Verify the installation (restart the terminal before this step):

   ```powershell
   terraform --version
   ```

### AWS CLI v2

1. Install the official package in silent mode:

   ```powershell
   Start-Process msiexec.exe -ArgumentList '/i https://awscli.amazonaws.com/AWSCLIV2.msi /qn' -Wait
   ```

2. Refresh the active PowerShell session's variables:

   ```powershell
   $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
               [System.Environment]::GetEnvironmentVariable("Path","User")
   ```

3. Configure your access credentials:

   ```powershell
   aws configure
   ```

   You will be prompted for the following:

   | Field | Value |
   |---|---|
   | AWS Access Key ID | *(your credential)* |
   | AWS Secret Access Key | *(your credential)* |
   | Default region name | `us-east-1` |
   | Default output format | `json` |

   > ⚠️ **Never** share or push your credentials to a repository. See the [Security Notes](#security-notes) section.

---

## Project Structure

```text
Proyecto-MEAN/
│
├── main.tf                  # Orchestration: calls all modules
├── variables.tf              # Global project variables
├── outputs.tf                # Consolidated deployment outputs
│
├── modules/
│   ├── vpc/                  # Network, subnets, NAT Gateway
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/              # Security Groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/               # EC2 instances (Node.js and MongoDB)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── alb/                   # Application Load Balancer
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── README.md
```

To create this structure from scratch:

```powershell
mkdir C:\Proyecto-MEAN
cd C:\Proyecto-MEAN
mkdir modules\vpc, modules\security, modules\compute, modules\alb

New-Item modules\vpc\main.tf, modules\vpc\variables.tf, modules\vpc\outputs.tf -ItemType File
New-Item modules\security\main.tf, modules\security\variables.tf, modules\security\outputs.tf -ItemType File
New-Item modules\compute\main.tf, modules\compute\variables.tf, modules\compute\outputs.tf -ItemType File
New-Item modules\alb\main.tf, modules\alb\variables.tf, modules\alb\outputs.tf -ItemType File
```

---

## Usage

All commands are run from the project root (`C:\Proyecto-MEAN`).

### 1. Initialize Terraform

Downloads the required providers and modules:

```powershell
terraform init
```

### 2. Validate the Configuration

Checks syntax and dependencies between modules:

```powershell
terraform validate
```

### 3. Deploy the Infrastructure

Creates the 25 resources defined in AWS:

```powershell
terraform apply --auto-approve
```

> 💡 It's recommended to run `terraform plan` first to review the changes before applying them in a real environment. The `--auto-approve` flag is used here since this is a lab environment.

### 4. Destroy the Infrastructure

To avoid unnecessary costs, destroy all resources once testing is complete:

```powershell
terraform destroy --auto-approve
```

Expected result:

```text
Destroy complete! Resources: 25 destroyed.
```

---

## Outputs

After `terraform apply` completes, the following outputs are generated:

| Output | Description |
|---|---|
| `alb_dns_name` | Public DNS record of the Load Balancer, the entry point for external HTTP requests |
| `mongodb_private_ip` | Fixed private IP of the MongoDB instance, used for internal communication with the application |
| `nat_gateway_public_ip` | Public IP of the NAT Gateway, allowing resources in private subnets to reach the internet |
| `nodejs_private_ips` | Private IPs of the two EC2 instances running the Node.js application |
| `nodejs_public_ips` | Empty by design (`""`); confirms that the application instances have no exposed public interface |

---

## Security Notes

- Do not hardcode AWS credentials in `.tf` files; use environment variables, `aws configure`, or a secrets manager instead.
- Add a `.gitignore` file that excludes `*.tfstate`, `*.tfstate.backup`, `.terraform/`, and any `*.tfvars` file containing sensitive data.
- The Node.js and MongoDB instances intentionally have no public IP as part of a defense-in-depth design; all external traffic must pass through the ALB.

---

## License

This project is distributed for educational/lab purposes. Update this section with the license you'd like to apply (e.g., MIT).
