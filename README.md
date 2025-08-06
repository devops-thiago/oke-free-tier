# OKE Cluster on OCI Free Tier - A Developer's Learning Journey

[![Terraform CI](https://github.com/devops-thiago/oke-free-tier/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/devops-thiago/oke-free-tier/actions/workflows/terraform-ci.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=devops-thiago_oke-free-tier&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=devops-thiago_oke-free-tier)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=devops-thiago_oke-free-tier&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=devops-thiago_oke-free-tier)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=devops-thiago_oke-free-tier&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=devops-thiago_oke-free-tier)
[![Go Report Card](https://goreportcard.com/badge/github.com/devops-thiago/oke-free-tier)](https://goreportcard.com/report/github.com/devops-thiago/oke-free-tier)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-623CE4?logo=terraform)](https://www.terraform.io/)
[![OCI](https://img.shields.io/badge/OCI-Oracle_Cloud-F80000?logo=oracle)](https://www.oracle.com/cloud/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33+-326CE5?logo=kubernetes)](https://kubernetes.io/)

> 🎓 **A complete Oracle Container Engine for Kubernetes (OKE) cluster running entirely on OCI's Always Free Tier - perfect for learning, testing, and small projects**

## 💭 Why This Project?

As developers, we're always looking for ways to:
- 🧪 **Test our applications** in a real cloud environment
- 📚 **Learn new technologies** like Kubernetes without breaking the bank
- 🚀 **Prototype and demo** our ideas to stakeholders
- 🛠️ **Practice DevOps skills** with real infrastructure
- 💼 **Build our portfolio** with actual cloud projects

The problem? Cloud costs can add up quickly, especially when experimenting. This project demonstrates how you can get a full Kubernetes cluster with enterprise-grade features using only OCI's Always Free Tier.

## 🎁 What OCI Always Free Tier Offers

Oracle Cloud Infrastructure's Always Free Tier is genuinely free (no time limits, no credit card expiration surprises):

- **4 ARM-based OCPUs** - Real compute power for your applications
- **24GB of RAM** - Sufficient for multiple microservices
- **200GB of storage** - Boot volumes and block storage
- **Load balancers and networking** - Production-grade infrastructure components
- **10TB outbound data transfer/month** - More than enough for development and testing

**Perfect for developers who want to learn and experiment without cost concerns!**

## 💪 What This Project Demonstrates

This repository proves that you can build and run:

🏗️ **Enterprise-Grade Infrastructure**
- Full Oracle Container Engine for Kubernetes (OKE) cluster
- Production networking with VCN, subnets, gateways
- Load balancers and ingress controllers

🔒 **Security & Best Practices**
- Private worker nodes (no public IPs)
- Network segmentation and security groups
- Automated security scanning with Trivy
- Infrastructure as Code with full validation

🛠️ **DevOps Excellence**
- Terraform for infrastructure automation
- CI/CD pipelines with GitHub Actions
- Automated testing with Terratest
- Code quality analysis with SonarQube
- Dependency management with Dependabot

🌐 **Real Applications**
- Container workloads and deployments
- Service networking and load balancing

## 🚀 Perfect for Developer Use Cases

**What can you realistically run on this free cluster?**

### 📚 **Learning & Skill Development**
- Practice Kubernetes concepts hands-on
- Learn Infrastructure as Code with Terraform
- Experiment with CI/CD pipelines
- Test different deployment strategies (blue-green, canary, etc.)
- Master DevOps tools like Helm, Prometheus, and Grafana

### 🧪 **Development & Testing**
- Host your development environments
- Test microservices architectures
- Validate containerized applications before production
- Run integration tests in a real cloud environment
- Debug networking and storage issues

### 💼 **Portfolio & Demos**
- Showcase your projects with real URLs
- Create impressive technical demos
- Build a personal cloud lab for interviews
- Host your blog, portfolio, or documentation
- Demonstrate your cloud and Kubernetes skills

### 🚀 **Small Production Workloads**
- Personal projects and side hustles
- MVP applications for startups
- Internal tools and automation
- Static websites with dynamic backends
- API services for mobile apps

**Resource Reality Check:** 4 CPUs + 24GB RAM is plenty for multiple small applications, databases, and development tools running simultaneously!

## 🎨 Architecture: Production-Ready by Design

## Architecture Overview

### Network Architecture

```
Internet
    │
    ▼
┌─────────────────┐
│ Internet Gateway│
└─────────────────┘
    │
    ▼
┌─────────────────┐    ┌─────────────────┐
│ Load Balancer   │    │ Service Gateway │
│ Subnet          │    │                 │
│ (10.0.20.0/24)  │    │ (OCI Services)  │
└─────────────────┘    └─────────────────┘
    │                        │
    ▼                        ▼
┌─────────────────┐    ┌─────────────────┐
│ NAT Gateway     │    │ Private Nodes   │
│                 │    │ Subnet          │
│ (Internet)      │    │ (10.0.10.0/24)  │
└─────────────────┘    └─────────────────┘
```

### Components

- **VCN**: Virtual Cloud Network with CIDR `10.0.0.0/16`
- **Load Balancer Subnet**: Public subnet for load balancer services
- **Node Subnet**: Private subnet for Kubernetes worker nodes
- **Internet Gateway**: Provides internet access for public services
- **NAT Gateway**: Allows private nodes to access internet
- **Service Gateway**: Direct access to OCI services (container registry, etc.)

### Security

- **Private Nodes**: Worker nodes are in private subnet with no public IPs
- **Restricted Access**: SSH and API access restricted to specified IP ranges
- **Network Segmentation**: Proper isolation between public and private components
- **Security Lists**: Granular control over network traffic

## Cluster Specifications

- **Nodes**: 4 ARM-based worker nodes
- **Compute**: 4 OCPUs total (1 OCPU per node)
- **Memory**: 24GB total (6GB per node)
- **Storage**: 120GB total (30GB per node)
- **Shape**: VM.Standard.A1.Flex
- **Kubernetes Version**: v1.33.1

## Prerequisites

### OCI Free Tier Account

If you don't have an OCI account yet, follow these steps to create a free one:

1. **Visit Oracle Cloud**: Go to [cloud.oracle.com](https://cloud.oracle.com)
2. **Start Free**: Click "Start for free" or "Try Oracle Cloud Free Tier"
3. **Account Information**: Fill in your details:
   - Country/Territory
   - Name and email address
   - Phone number for verification
4. **Verification**: Complete phone and email verification
5. **Payment Method**: Add a credit card for verification (you won't be charged)
6. **Account Creation**: Wait for account provisioning (usually takes a few minutes)
7. **Sign In**: Access your new OCI Console

**Important Notes:**
- The Always Free Tier never expires and doesn't require a credit card after the initial verification
- You get $300 in credits for 30 days to try paid services (optional)
- Free tier resources are clearly marked in the console
- You can upgrade to paid anytime, but it's not required for this project

### Required Tools

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### OCI Requirements

- OCI account with appropriate permissions
- Compartment for resource creation
- User OCID and Tenancy OCID
- SSH public key for node access

## Configuration

### 1. Update Variables

Edit `terraform.tfvars` with your specific values:

```hcl
ssh_public_key = "ssh-ed25519 YOUR_PUBLIC_KEY_HERE"
user_ip = "YOUR_PUBLIC_IP/32"  # Restrict access to your IP
```

### 2. OCI Configuration

Ensure your OCI CLI is configured:

```bash
oci setup config
```

Or set environment variables:

```bash
export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..your_tenancy"
export TF_VAR_user_ocid="ocid1.user.oc1..your_user"
export TF_VAR_compartment_ocid="ocid1.compartment.oc1..your_compartment"
```

## Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Plan Deployment

```bash
terraform plan
```

### 3. Apply Configuration

```bash
terraform apply
```

### 4. Generate Kubeconfig

After successful deployment, generate your kubeconfig:

```bash
# Generate kubeconfig
$(terraform output -raw kubeconfig_command)
```

### 5. Verify Deployment

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Testing

### Automated Testing with Terratest

This project uses [Terratest](https://terratest.gruntwork.io/) for comprehensive infrastructure testing. The tests are designed to validate configuration without requiring real OCI resources, making them fast and CI/CD friendly.

```bash
# Run all tests
go test -v ./test/
```

#### What the Tests Cover

1. **TestTerraformValidation**: Validates the Terraform configuration syntax and structure
2. **TestTerraformFormat**: Ensures the Terraform code is properly formatted

These tests focus on configuration validation rather than resource provisioning, so they:
- Execute in seconds (no API calls required)
- Work perfectly in CI/CD pipelines
- Don't need OCI credentials or real resources
- Can run in parallel for faster execution

### CI/CD Testing

Every pull request automatically runs:
- ✅ **Terraform Format Check**: Ensures consistent code formatting
- ✅ **Terraform Validation**: Validates configuration syntax
- ✅ **TFLint Analysis**: Static analysis for best practices
- ✅ **Trivy Security Scan**: Security vulnerability assessment
- ✅ **Terratest Execution**: Go-based infrastructure tests
- ✅ **SonarCloud Analysis**: Code quality and maintainability

#### Setting up SonarCloud (Optional)

To enable code quality analysis with SonarCloud (free for public repos):

1. **Create SonarCloud account**: Go to [SonarCloud.io](https://sonarcloud.io) and sign up with GitHub
2. **Import your repository**: Select this repo in SonarCloud dashboard
3. **Update config files**:
   - In `sonar-project.properties`: Replace `YOUR_GITHUB_USERNAME` with your actual username
   - In README badges: Update the project key in badge URLs
4. **Generate token**: In SonarCloud → Account → Security → Generate new token
5. **Add GitHub secret**: In your repo → Settings → Secrets → Add `SONAR_TOKEN`

That's it! SonarCloud will now analyze your code on every PR.

### Local Development Testing

```bash
# Install pre-commit hooks
pip install pre-commit
pre-commit install

# Run all checks locally before commit
pre-commit run --all-files
```

### Manual Testing

1. **Network Connectivity**:
   ```bash
   # Test node internet access
   kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup google.com
   ```

2. **Service Access**:
   ```bash
   # Deploy test application
   kubectl create deployment nginx --image=nginx
   kubectl get svc
   ```

3. **OCI Services**:
   ```bash
   # Test container registry access
   kubectl run test-registry --image=container-registry.oracle.com/oci/hello-world-example --rm -it --restart=Never
   ```

## Usage Examples

### Deploy Applications

```bash
# Deploy a simple web application
kubectl create deployment web-app --image=nginx

# Expose service via LoadBalancer
kubectl expose deployment web-app --type=LoadBalancer --port=80
```

### Scale Applications

```bash
# Scale deployment
kubectl scale deployment web-app --replicas=3

# Check resource usage
kubectl top nodes
kubectl top pods
```

## Monitoring and Logging

### Cluster Monitoring

```bash
# Check node status
kubectl get nodes -o wide

# Check pod status
kubectl get pods --all-namespaces

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

### Resource Usage

```bash
# Monitor cluster metrics
kubectl top nodes
kubectl top pods --all-namespaces
```

## Cleanup

### Destroy Infrastructure

```bash
# Destroy all resources
terraform destroy

# Destroy specific resources
terraform destroy -target=oci_containerengine_node_pool.k8s_node_pool
```

### Cleanup Kubernetes Resources

```bash
# Delete all deployments
kubectl delete deployments --all

# Delete all services
kubectl delete services --all

# Delete all namespaces (except default and kube-system)
kubectl get namespaces | grep -v "default\|kube-system" | awk '{print $1}' | xargs kubectl delete namespace
```

## Troubleshooting

### Common Issues

1. **Node Registration Timeout**:
   - Check security list rules
   - Verify NAT Gateway configuration
   - Ensure proper DNS resolution

2. **Pod Scheduling Issues**:
   - Check node resources: `kubectl describe nodes`
   - Verify node labels: `kubectl get nodes --show-labels`

3. **Network Connectivity**:
   - Test node internet access
   - Verify security list rules
   - Check route table configuration

### Debug Commands

```bash
# Check node status
kubectl describe nodes

# Check pod events
kubectl describe pod <pod-name>

# Check service endpoints
kubectl get endpoints

# Test network connectivity
kubectl run test-connectivity --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default
```

## Security Best Practices

1. **Access Control**:
   - Restrict SSH access to specific IPs
   - Use RBAC for Kubernetes access
   - Regularly rotate SSH keys

2. **Network Security**:
   - Keep nodes in private subnets
   - Use security lists to restrict traffic
   - Monitor network access logs

3. **Resource Management**:
   - Set resource limits on pods
   - Monitor resource usage
   - Implement pod disruption budgets

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 