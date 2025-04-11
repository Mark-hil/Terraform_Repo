output "load_balancer_ip" {
  description = "External IP of the LoadBalancer service"
  value       = kubernetes_service.app.status.0.load_balancer.0.ingress.0.hostname
}
