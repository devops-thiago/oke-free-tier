output "cluster_id" {
  description = "The OCID of the OKE cluster"
  value       = oci_containerengine_cluster.k8s_cluster.id
}

output "cluster_name" {
  description = "The name of the OKE cluster"
  value       = oci_containerengine_cluster.k8s_cluster.name
}

output "cluster_kubernetes_version" {
  description = "The Kubernetes version of the cluster"
  value       = oci_containerengine_cluster.k8s_cluster.kubernetes_version
}

output "cluster_endpoint" {
  description = "The endpoint of the OKE cluster"
  value       = oci_containerengine_cluster.k8s_cluster.endpoints[0].public_endpoint
  sensitive   = true
}

output "region" {
  description = "The OCI region where the cluster is deployed"
  value       = var.region
}

output "node_pool_id" {
  description = "The OCID of the node pool"
  value       = oci_containerengine_node_pool.k8s_node_pool.id
}

output "vcn_id" {
  description = "The OCID of the VCN"
  value       = oci_core_vcn.k8s_vcn.id
}

output "nat_gateway_id" {
  description = "The OCID of the NAT Gateway"
  value       = oci_core_nat_gateway.k8s_nat.id
}

output "kubeconfig_command" {
  description = "Command to generate kubeconfig (requires OCI CLI)"
  value       = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.k8s_cluster.id} --file ~/.kube/config --region ${var.region} --token-version 2.0.0 --kube-endpoint ${oci_containerengine_cluster.k8s_cluster.endpoints[0].public_endpoint}"
}

