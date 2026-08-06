output "service_cluster_ip" {
  value = { for k, v in module.service : k => v.service_cluster_ip }
}