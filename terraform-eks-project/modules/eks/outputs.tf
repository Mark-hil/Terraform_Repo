#####################################
# EKS Cluster Outputs
#####################################
output "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_ca_certificate" {
  description = "Certificate authority data for EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.main.version
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.main.arn
}

#####################################
# Kubeconfig Output
#####################################
output "kubeconfig" {
  description = "Kubeconfig for connecting to the EKS cluster"
  value       = <<KUBECONFIG
apiVersion: v1
kind: Config
preferences: {}

clusters:
- cluster:
    server: ${aws_eks_cluster.main.endpoint}
    certificate-authority-data: ${aws_eks_cluster.main.certificate_authority[0].data}
  name: ${aws_eks_cluster.main.name}

contexts:
- context:
    cluster: ${aws_eks_cluster.main.name}
    user: ${aws_eks_cluster.main.name}
  name: ${aws_eks_cluster.main.name}

current-context: ${aws_eks_cluster.main.name}

users:
- name: ${aws_eks_cluster.main.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.main.name}"
KUBECONFIG
}