variable "compartment_ocid" {
  description = "The OCID of the compartment to create resources in"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaatoo4a2zzmor3jvfuxju6kvst4xglwnh2oq66uvolzh6crc7nklpa" # Using root compartment for simplicity
}

variable "region" {
  description = "The OCI region"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = "v1.33.1" # Latest supported version
}

variable "node_image_id" {
  description = "The OCID of the image to use for worker nodes"
  type        = string
  default     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaabrqkpvmnfmrc36klerznraywnbujoe722qpzysuonofhsgosx6pa" # ARM64 Oracle Linux
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the nodes"
  type        = string
  default     = "" # Will be set interactively or via terraform.tfvars

  validation {
    condition     = can(regex("^ssh-(rsa|ed25519|ecdsa)", var.ssh_public_key)) || var.ssh_public_key == ""
    error_message = "SSH public key must be in valid format (ssh-rsa, ssh-ed25519, or ssh-ecdsa)."
  }
}

variable "user_ip" {
  description = "Your public IP address for SSH and API access restrictions"
  type        = string
  default     = "0.0.0.0/0" # TODO: Set to your actual IP for security

  validation {
    condition     = can(cidrhost(var.user_ip, 0))
    error_message = "User IP must be a valid CIDR block (e.g., 1.2.3.4/32)."
  }
}
