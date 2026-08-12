module "service" {
  # source              = "./modules"
  source              = "git::https://github.com/ashishkumar256/atlantis-demo.git//modules?ref=master"
  for_each            = local.info
  deployment_name     = each.key
  namespace_name      = each.value.namespace_name
  app_labels          = each.value.app_labels
  replica_count       = each.value.replica_count
  nginx_image         = each.value.nginx_image
  container_resources = each.value.container_resources
  service_config      = each.value.service_config
  hpa_max_replicas    = each.value.hpa_max_replicas
  hpa_metrics         = each.value.hpa_metrics
}
