output "service_cluster_ip" {
  description = "The dynamic, internal virtual IP assigned to this service by the cluster (ClusterIP)."
  value       = kubernetes_service.nginx_service.spec[0].cluster_ip
}