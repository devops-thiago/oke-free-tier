# OKE Cluster Configuration
# This configuration creates a production-ready OKE cluster with:
# - 4 ARM-based Compute VMs (4 nodes × 1 OCPU = 4 cores)
# - 24GB memory (4 nodes × 6GB)
# - 120GB storage (4 nodes × 30GB)
# - NAT Gateway for private node internet access
# - Load Balancer for public service access
# - Service Gateway for OCI services access

# Configure the Oracle Cloud Infrastructure Provider
provider "oci" {
  config_file_profile = "DEFAULT"
}


# Create VCN
resource "oci_core_vcn" "k8s_vcn" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = [local.vcn_cidr]
  display_name   = "k8s-vcn"
  dns_label      = "k8svcn"

  freeform_tags = local.common_tags
}

# Create Internet Gateway
resource "oci_core_internet_gateway" "k8s_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-igw"
}

# Create NAT Gateway for private nodes
resource "oci_core_nat_gateway" "k8s_nat" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-nat"
}

# Create Service Gateway for OCI services access
resource "oci_core_service_gateway" "k8s_sgw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-sgw"

  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
}

# Create Route Table for public subnets
resource "oci_core_route_table" "k8s_public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.k8s_igw.id
  }
}

# Create Route Table for private subnets (nodes)
resource "oci_core_route_table" "k8s_private_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.k8s_nat.id
  }

  route_rules {
    destination       = data.oci_core_services.all_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.k8s_sgw.id
  }
}

# Create Security List for Load Balancer Subnet
resource "oci_core_security_list" "k8s_lb_seclist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-lb-seclist"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Allow all traffic within VCN (required for load balancer to node communication)
  ingress_security_rules {
    protocol = "all"
    source   = "10.0.0.0/16"
  }

  # HTTP traffic
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS traffic
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # Kubernetes API server access (port 6443)
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
}

# Create Security List for Node Subnet
resource "oci_core_security_list" "k8s_node_seclist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-node-seclist"

  # Allow all egress traffic (nodes need internet access via NAT Gateway)
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Allow all traffic within VCN (required for internal cluster communication)
  ingress_security_rules {
    protocol = "all"
    source   = "10.0.0.0/16"
  }

  # SSH access (temporary broad access for testing)
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Kubernetes API server communication (HTTPS) - from nodes to control plane
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Kubelet API (read-write) - from control plane to nodes
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    tcp_options {
      min = 10250
      max = 10250
    }
  }

  # Kubelet API (read-only) - from control plane to nodes
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    tcp_options {
      min = 10255
      max = 10255
    }
  }

  # kube-proxy health check - from control plane to nodes
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    tcp_options {
      min = 10256
      max = 10256
    }
  }

  # Health check endpoints - from control plane to nodes
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    tcp_options {
      min = 10248
      max = 10249
    }
  }

  # etcd client communication - from control plane to nodes
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    tcp_options {
      min = 2379
      max = 2380
    }
  }

  # CNI (Container Network Interface) - Flannel VXLAN
  ingress_security_rules {
    protocol = "17"
    source   = "10.0.0.0/16" # Allow from entire VCN for control plane access
    udp_options {
      min = 8472
      max = 8472
    }
  }

  # ICMP for path discovery
  ingress_security_rules {
    protocol = "1"
    source   = "10.0.0.0/16"
    icmp_options {
      type = 3
      code = 4
    }
  }

  # ICMP echo (ping) for troubleshooting
  ingress_security_rules {
    protocol = "1"
    source   = "10.0.0.0/16"
    icmp_options {
      type = 8
    }
  }
}

# Create Security List for NodePort Services
resource "oci_core_security_list" "k8s_nodeport_seclist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "k8s-nodeport-seclist"

  # Allow all egress traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # NodePort services (30000-32767) - temporary broad access for testing
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 30000
      max = 32767
    }
  }

  # Allow all traffic within VCN
  ingress_security_rules {
    protocol = "all"
    source   = "10.0.0.0/16"
  }
}

# Create Load Balancer Subnet
resource "oci_core_subnet" "k8s_lb_subnet" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.k8s_vcn.id
  cidr_block        = local.subnets.public.cidr
  display_name      = "k8s-lb-subnet"
  dns_label         = local.subnets.public.dns_label
  security_list_ids = [oci_core_security_list.k8s_lb_seclist.id]
  route_table_id    = oci_core_route_table.k8s_public_rt.id
  dhcp_options_id   = oci_core_vcn.k8s_vcn.default_dhcp_options_id

  freeform_tags = local.common_tags
}

# Create Node Subnet (private with NAT Gateway)
resource "oci_core_subnet" "k8s_node_subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.k8s_vcn.id
  cidr_block                 = local.subnets.private.cidr
  display_name               = "k8s-node-subnet"
  dns_label                  = local.subnets.private.dns_label
  security_list_ids          = [oci_core_security_list.k8s_node_seclist.id, oci_core_security_list.k8s_nodeport_seclist.id]
  route_table_id             = oci_core_route_table.k8s_private_rt.id
  dhcp_options_id            = oci_core_vcn.k8s_vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true # Make nodes private

  freeform_tags = local.common_tags
}

# Create OKE Cluster
resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name               = local.project_name
  vcn_id             = oci_core_vcn.k8s_vcn.id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.k8s_lb_subnet.id
  }

  options {
    service_lb_subnet_ids = [oci_core_subnet.k8s_lb_subnet.id]

    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }

    kubernetes_network_config {
      pods_cidr     = local.k8s_network.pods_cidr
      services_cidr = local.k8s_network.services_cidr
    }
  }

  freeform_tags = local.common_tags
}

# Create Node Pool
resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name               = local.node_pool.name

  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.k8s_node_subnet.id
    }
    size = local.node_pool.size
  }

  node_shape = local.node_pool.shape

  node_shape_config {
    memory_in_gbs = local.node_pool.memory_gb
    ocpus         = local.node_pool.ocpus
  }

  node_source_details {
    image_id                = var.node_image_id
    source_type             = "IMAGE"
    boot_volume_size_in_gbs = local.node_pool.boot_volume_gb
  }

  initial_node_labels {
    key   = "name"
    value = local.project_name
  }

  ssh_public_key = var.ssh_public_key

  freeform_tags = local.common_tags
}
