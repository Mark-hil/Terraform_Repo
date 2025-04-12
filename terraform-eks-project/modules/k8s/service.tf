#####################################
# Application Service
#####################################
resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = var.app_name
      env = var.environment_variables["ENV"]
    }
  }

  spec {
    # Selector to match the deployment pods
    selector = {
      app = kubernetes_deployment.app.metadata[0].name
    }

    # Service port configuration
    port {
      name        = "http"
      port        = var.service_port
      target_port = var.container_port
      protocol    = "TCP"
    }

    # Service type (LoadBalancer, ClusterIP, NodePort)
    type = var.service_type
  }
}
