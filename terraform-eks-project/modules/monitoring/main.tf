resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "server.persistentVolume.enabled"
    value = "false"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"

  set {
    name  = "persistence.enabled"
    value = "false"
  }

  set {
    name  = "adminPassword"
    value = "admin"
  }
}


#####################################
# CloudWatch Monitoring
#####################################
resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = var.log_group_name
  retention_in_days = 30
  tags              = var.tags
}
