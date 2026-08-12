environment = {
  default = {   
    nginx = {
      namespace_name  = "poc"
      app_labels = {
        app         = "nginx"
        environment = "demo"
      }
      replica_count = 1
      nginx_image   = "nginx:latest"
      container_resources = {
        requests = {
          cpu    = "10m"
          memory = "20Mi"
        }
        limits = {
          cpu    = "20m"
          memory = "40Mi"
        }
      }
      service_config = {
        type        = "NodePort"
        port        = 80
        target_port = 80
        node_port   = 30080
        protocol    = "TCP"
      }
      hpa_max_replicas = 2
      hpa_metrics = {
        cpu    = 70
        memory = 70
      }
    }
  },
  dev = {},
  stg = {}
}
