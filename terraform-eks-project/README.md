# Terraform EKS Project

This repository contains Terraform configurations for deploying a production-ready EKS cluster on AWS with supporting infrastructure.

## 🏗 Architecture

The project sets up the following AWS resources:

- **VPC & Networking**
  - Custom VPC with public/private subnets
  - Internet Gateway and NAT Gateways
  - Route tables and security groups

- **EKS Cluster**
  - Managed node groups
  - IAM roles and policies
  - Kubernetes add-ons

- **Supporting Infrastructure**
  - EC2 bastion host
  - S3 bucket for Terraform state
  - DynamoDB table for state locking
  - CloudWatch logging with S3 archival
  - Application Load Balancer

## 📂 Project Structure

```
terraform-eks-project/
├── modules/
│   ├── ec2/                 # EC2 instance configuration
│   ├── eks/                 # EKS cluster and node groups
│   ├── k8s/                 # Kubernetes resources
│   ├── s3-backend/         # S3 state backend
│   ├── security_group/     # Security group rules
│   └── vpc/                # VPC and networking
├── scripts/
│   ├── setup.sh           # Initial setup and backend configuration
│   ├── deploy.sh          # Safe deployment with cost estimation
│   ├── update-kubeconfig.sh # Configure kubectl access
│   ├── cleanup.sh         # Clean up all resources
│   └── logs-setup.sh      # Configure logging pipeline
├── backend.tf              # Backend configuration
├── main.tf                # Main infrastructure
├── outputs.tf             # Output definitions
├── variables.tf           # Input variables
└── versions.tf            # Provider versions
```

## 🚀 Getting Started

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or newer
- kubectl installed
- AWS IAM permissions for creating all required resources

### Initial Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd terraform-eks-project
   ```

2. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```

3. Create a terraform.tfvars file:
   ```hcl
   aws_region   = "eu-west-1"
   env_prefix   = "dev"
   project_name = "my-eks-project"
   vpc_cidr     = "10.0.0.0/16"
   ```

4. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```
   This will:
   - Initialize Terraform
   - Create the S3 backend
   - Configure the backend.tf file

5. Deploy the infrastructure:
   ```bash
   ./scripts/deploy.sh
   ```
   This will:
   - Format Terraform files
   - Create an execution plan
   - Show cost estimation for all resources
   - Ask for confirmation before applying
   - Apply the changes if confirmed

6. Configure logging (optional):
   ```bash
   ./scripts/logs-setup.sh
   ```

### Accessing the Cluster

After deployment:

1. Configure cluster access:
   ```bash
   ./scripts/update-kubeconfig.sh
   ```
   This will:
   - Update your kubeconfig file
   - Test the connection to the cluster
   - Display available nodes

### Cleanup

To remove all resources:

1. Run the cleanup script:
   ```bash
   ./scripts/cleanup.sh
   ```
   This will:
   - Destroy all Terraform-managed resources
   - Empty and delete the S3 state bucket
   - Clean up any remaining resources

## 🔧 Configuration

### Port Configuration

All port configurations are centralized in the root `variables.tf` file:

```hcl
locals {
  ports = {
    http = {
      container = 80
      service   = 80
    }
    ssh  = 22
    # ... other port configurations
  }
}
```

### Module Configuration

Each module has its own variables that can be configured. Key configurations include:

- **VPC Module**
  - CIDR blocks
  - Availability zones
  - Subnet configurations

- **EKS Module**
  - Node group size
  - Instance types
  - Kubernetes version

- **K8s Module**
  - Application configuration
  - Service type
  - Health checks

## 📊 Monitoring and Logging

The project includes comprehensive logging:

- CloudWatch Log Groups for EKS logs
- Kinesis Firehose for log archival to S3
- ALB access logs stored in S3
- Container logs forwarded to CloudWatch

## 💰 Cost Management

The project includes cost management features:

### Cost Estimation

The `deploy.sh` script uses Infracost to provide cost estimates before deployment:
- Shows estimated costs for all AWS resources
- Breaks down costs by resource type
- Identifies potential cost optimizations
- Requires confirmation before applying changes

### Cost Optimization Features

1. **Auto Scaling**
   - EKS node groups scale based on demand
   - Spot instances option for cost savings

2. **Resource Limits**
   - Container resource limits prevent over-provisioning
   - Configurable CPU and memory requests

3. **Storage Management**
   - S3 lifecycle policies for log archival
   - EBS volume size limits

4. **Monitoring**
   - CloudWatch metrics for resource utilization
   - Cost allocation tags for billing analysis

## 🔒 Security

Security features include:

- Network segmentation with public/private subnets
- Security groups with least privilege access
- IAM roles with minimal required permissions
- Encrypted S3 buckets for sensitive data
- TLS termination at ALB

## 🔄 State Management

Terraform state is stored in S3 with the following features:

- Encrypted S3 bucket
- DynamoDB table for state locking
- Versioning enabled
- Access logging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📜 Script Usage

All scripts are located in the `scripts/` directory. Make them executable first:

```bash
chmod +x scripts/*.sh
```

### Initial Setup
```bash
./scripts/setup.sh
```
Use this when:
- Setting up the project for the first time
- Configuring S3 backend
- Initializing Terraform

### Deployment
```bash
./scripts/deploy.sh
```
Use this when:
- Deploying infrastructure changes
- Getting cost estimates before deployment
- Applying Terraform changes safely

### Kubernetes Configuration
```bash
./scripts/update-kubeconfig.sh
```
Use this when:
- Accessing the EKS cluster
- Setting up kubectl
- Testing cluster connectivity

### Logging Setup
```bash
./scripts/logs-setup.sh
```
Use this when:
- Setting up CloudWatch logging
- Configuring log archival to S3
- Setting up log subscription filters

### Cleanup
```bash
./scripts/cleanup.sh
```
Use this when:
- Destroying all resources
- Cleaning up S3 buckets
- Removing the entire infrastructure

## 📖 Detailed Script Documentation

### setup.sh

Initial project setup script.

**Prerequisites:**
- AWS CLI configured with valid credentials
- Terraform v1.0.0+
- kubectl installed

**What it does:**
1. Validates all prerequisites are installed
2. Initializes Terraform workspace
3. Creates S3 bucket for state storage
4. Creates DynamoDB table for state locking
5. Updates backend.tf with correct values
6. Re-initializes Terraform with remote state

**Example output:**
```bash
Checking prerequisites...
AWS CLI ✓
Terraform ✓
kubectl ✓

Initializing Terraform...
Creating S3 backend...
Updating backend configuration...
```

### deploy.sh

Safe deployment script with cost estimation.

**Prerequisites:**
- Infracost CLI installed
- Terraform initialized
- AWS credentials configured

**What it does:**
1. Formats all Terraform files
2. Creates execution plan
3. Generates cost estimation
4. Shows resource changes
5. Asks for confirmation
6. Applies changes if confirmed

**Cost estimation example:**
```bash
Monthly cost estimate:

 Project: terraform-eks-project

 Name                                      Price
 ─────────────────────────────────────    ─────
 aws_eks_cluster.main                     $73.00
 aws_eks_node_group.main                  $9.56
 TOTAL                                   $82.56
```

### update-kubeconfig.sh

Kubernetes configuration script.

**Prerequisites:**
- EKS cluster deployed
- AWS CLI configured
- kubectl installed

**What it does:**
1. Retrieves cluster name from Terraform output
2. Gets AWS region from configuration
3. Updates kubectl context
4. Tests cluster connectivity
5. Shows available nodes

**Example output:**
```bash
Updating kubeconfig for cluster: my-eks-cluster
Added new context arn:aws:eks:region:account:cluster/my-eks-cluster

NAME                          STATUS   ROLES    AGE
ip-10-0-1-20.ec2.internal    Ready    <none>   1h
ip-10-0-2-180.ec2.internal   Ready    <none>   1h
```

### logs-setup.sh

Logging infrastructure setup script.

**Prerequisites:**
- EKS cluster running
- Required IAM permissions
- CloudWatch enabled

**What it does:**
1. Enables EKS control plane logging
2. Creates CloudWatch log groups
3. Sets up Kinesis Firehose delivery stream
4. Configures S3 archival
5. Creates log subscription filters

**Log types enabled:**
- API server logs
- Audit logs
- Authenticator logs
- Controller manager logs
- Scheduler logs

### cleanup.sh

Resource cleanup script.

**Prerequisites:**
- AWS credentials with delete permissions
- Terraform state accessible

**What it does:**
1. Prompts for confirmation
2. Destroys all Terraform-managed resources
3. Empties S3 buckets (logs, state)
4. Deletes S3 buckets
5. Removes DynamoDB lock table

**Safety features:**
- Double confirmation for destructive actions
- Validates state file accessibility
- Checks for dependent resources
- Shows resources to be destroyed

## 🆘 Support

For support, please open an issue in the repository or contact the maintainers.
