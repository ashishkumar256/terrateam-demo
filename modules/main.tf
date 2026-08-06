# ----------------------------
# NGINX Namespace
# ----------------------------
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.namespace_name
  }
}

# ----------------------------
# NGINX Deployment
# ----------------------------
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.nginx.metadata[0].name
    labels    = var.app_labels
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = var.app_labels
    }

    template {
      metadata {
        labels = var.app_labels
      }

      spec {
        container {
          name  = lookup(var.app_labels, "app", "nginx")
          image = var.nginx_image

          port {
            container_port = var.service_config.port
          }

          resources {
            requests = var.container_resources.requests
            limits   = var.container_resources.limits
          }
        }
      }
    }
  }
}

# ----------------------------
# NGINX NodePort Service
# ----------------------------
# ----------------------------
# NGINX NodePort Service
# ----------------------------
resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "${lookup(var.app_labels, "app", "nginx")}-service"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }

  spec {
    selector = var.app_labels 
    type     = var.service_config.type

    port {
      port        = var.service_config.port
      target_port = var.service_config.target_port
      node_port   = var.service_config.type == "NodePort" ? var.service_config.node_port : null
      protocol    = var.service_config.protocol
    }
  }
}


# ----------------------------
# NGINX Horizontal Pod Autoscaler (v2)
# ----------------------------
resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx_hpa" {
  metadata {
    name      = "${lookup(var.app_labels, "app", "nginx")}-hpa"
    namespace = kubernetes_namespace.nginx.metadata[0].name
    labels    = var.app_labels
  }

  spec {
    min_replicas = var.replica_count
    max_replicas = var.hpa_max_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    # DYNAMIC BLOCK: Safely handles strings internally while processing user metrics
    dynamic "metric" {
      for_each = var.hpa_metrics
      content {
        type = "Resource"

        resource {
          name = metric.key # Evaluates to "cpu" or "memory"

          target {
            type                = "Utilization" 
            average_utilization = metric.value
          }
        }
      }
    }
  }
}