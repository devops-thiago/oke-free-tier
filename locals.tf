# Local values for consistent naming and configuration
locals {
  # Project naming
  project_name = "oke-free-tier"
  environment  = "dev"

  # Common tags for all resources
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
    Repository  = "https://github.com/devops-thiago/oke-free-tier"
  }

  # Network configuration
  vcn_cidr = "10.0.0.0/16"

  subnets = {
    public = {
      cidr      = "10.0.20.0/24"
      dns_label = "k8slb"
    }
    private = {
      cidr      = "10.0.10.0/24"
      dns_label = "k8snode"
    }
  }

  # Kubernetes configuration
  k8s_network = {
    pods_cidr     = "10.244.0.0/16"
    services_cidr = "10.96.0.0/16"
  }

  # Node pool configuration
  node_pool = {
    name           = "${local.project_name}-pool"
    size           = 4
    shape          = "VM.Standard.A1.Flex"
    memory_gb      = 6
    ocpus          = 1
    boot_volume_gb = 50
  }
}
