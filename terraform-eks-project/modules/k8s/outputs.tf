#####################################
# Service Outputs
#####################################
output "load_balancer_ip" {
  description = "External hostname/IP of the LoadBalancer service"
  value       = try(kubernetes_service.app.status.0.load_balancer.0.ingress.0.hostname, null)
}

output "service_name" {
  description = "Name of the Kubernetes service"
  value       = kubernetes_service.app.metadata[0].name
}

output "service_port" {
  description = "Port exposed by the service"
  value       = kubernetes_service.app.spec[0].port[0].port
}

#####################################
# Application Outputs
#####################################
output "namespace" {
  description = "Namespace where the application is deployed"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "deployment_name" {
  description = "Name of the Kubernetes deployment"
  value       = kubernetes_deployment.app.metadata[0].name
}

output "replicas" {
  description = "Number of desired replicas in the deployment"
  value       = kubernetes_deployment.app.spec[0].replicas
}
