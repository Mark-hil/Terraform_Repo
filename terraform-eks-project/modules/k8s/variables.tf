#####################################
# EKS Cluster Configuration
#####################################
variable "cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Certificate authority data for the EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster for authentication"
  type        = string
}

#####################################
# Application Configuration
#####################################
variable "namespace" {
  description = "Kubernetes namespace for application deployment"
  type        = string
  default     = "default"

  validation {
    condition     = can(regex("^[a-z0-9][-a-z0-9]*[a-z0-9]$", var.namespace))
    error_message = "Namespace must consist of lowercase alphanumeric characters or '-', and must start and end with an alphanumeric character."
  }
}

variable "app_name" {
  description = "Name of the application, used for resource naming"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][-a-z0-9]*[a-z0-9]$", var.app_name))
    error_message = "Application name must consist of lowercase alphanumeric characters or '-', and must start and end with an alphanumeric character."
  }
}

variable "container_image" {
  description = "Docker image for the application (format: repository/image:tag)"
  type        = string
}

variable "replicas" {
  description = "Number of pod replicas to maintain"
  type        = number
  default     = 1

  validation {
    condition     = var.replicas > 0
    error_message = "Number of replicas must be greater than 0."
  }
}

#####################################
# Resource Configuration
#####################################
variable "cpu_limit" {
  description = "CPU limit for each container (format: 500m, 1.0)"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit for each container (format: 512Mi, 1Gi)"
  type        = string
  default     = "512Mi"
}

variable "cpu_request" {
  description = "CPU request for each container (format: 250m, 0.5)"
  type        = string
  default     = "250m"
}

variable "memory_request" {
  description = "Memory request for each container (format: 256Mi, 512Mi)"
  type        = string
  default     = "256Mi"
}

#####################################
# Network Configuration
#####################################
variable "container_port" {
  description = "Port that the container listens on (defaults to local.ports.app.container)"
  type        = number
  default     = null

  validation {
    condition     = var.container_port == null || (var.container_port > 0 && var.container_port < 65536)
    error_message = "Container port must be between 1 and 65535."
  }
}

variable "service_port" {
  description = "Port that the service listens on (defaults to local.ports.app.service)"
  type        = number
  default     = null

  validation {
    condition     = var.service_port == null || (var.service_port > 0 && var.service_port < 65536)
    error_message = "Service port must be between 1 and 65535."
  }
}

variable "service_type" {
  description = "Type of Kubernetes service (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "LoadBalancer"

  validation {
    condition     = contains(["LoadBalancer", "ClusterIP", "NodePort"], var.service_type)
    error_message = "Service type must be one of: LoadBalancer, ClusterIP, NodePort."
  }
}

#####################################
# Health Check Configuration
#####################################
variable "health_check_path" {
  description = "HTTP path for liveness and readiness probes"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/", var.health_check_path))
    error_message = "Health check path must start with '/'."
  }
}

#####################################
# Environment Configuration
#####################################
variable "environment_variables" {
  description = "Map of environment variables to pass to the container"
  type        = map(string)
  default     = {}
}
