#####################################
# Provider Configuration
#####################################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

#####################################
# Namespace Configuration
#####################################
resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
      env  = var.environment_variables["ENV"]
    }
  }
}

#####################################
# Application Deployment
#####################################
resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = var.app_name
      env = var.environment_variables["ENV"]
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
          env = var.environment_variables["ENV"]
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.app_name

          # Resource limits and requests
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          # Environment variables
          dynamic "env" {
            for_each = var.environment_variables
            content {
              name  = env.key
              value = env.value
            }
          }

          # Container port
          port {
            container_port = var.container_port
            name          = "http"
          }

          # Health checks
          readiness_probe {
            http_get {
              path = var.health_check_path
              port = var.container_port
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            failure_threshold     = 3
            success_threshold    = 1
            timeout_seconds      = 1
          }

          liveness_probe {
            http_get {
              path = var.health_check_path
              port = var.container_port
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds      = 1
          }
        }
      }
    }
  }
}
