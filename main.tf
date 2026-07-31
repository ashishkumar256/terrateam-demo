
# ----------------------------
# NGINX Namespace
# ----------------------------
resource "kubernetes_namespace" "nginx_ns" {
  metadata {
    name = "poc"
  }
}

# ----------------------------
# NGINX Deployment
# ----------------------------
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name

    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }

          resources {
            requests = {
              cpu    = "1m"
              memory = "1Mi"
            }
            limits = {
              cpu    = "4m"
              memory = "4Mi"
            }
          }
        }
      }
    }
  }
}

# ----------------------------
# NGINX NodePort Service
# ----------------------------
resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-nodeport-service"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    type = "NodePort"

    port {
      port        = 80          # The port accessible inside the cluster via the service
      target_port = 80          # The port the container is listening on (container_port)
      node_port   = 30080       # Optional: Explicit port on the host node (range 30000-32767). Remove to let K8s auto-assign.
    }
  }
}

# ----------------------------
# NGINX Horizontal Pod Autoscaler (v2)
# ----------------------------
resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx_hpa" {
  metadata {
    name = "nginx-hpa"
    namespace = kubernetes_namespace.nginx_ns.metadata[0].name

    labels = {
      app = "nginx"
    }
  }

  spec {
    min_replicas = 1
    max_replicas = 5

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    # Scale up if average CPU utilization exceeds 10% of the requested amount
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 10
        }
      }
    }

    # Optional: Scale up if average Memory utilization exceeds 10%
    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = 10
        }
      }
    }
  }
}
