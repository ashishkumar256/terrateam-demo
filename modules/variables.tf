variable "namespace_name" {
  type        = string
  description = "The name of the Kubernetes namespace."
}

variable "deployment_name" {
  type        = string
  description = "The name of the NGINX deployment."
}

variable "app_labels" {
  type        = map(string)
  description = "Multi-app labels to apply to metadata, selectors, and match expressions."
}

variable "replica_count" {
  type        = number
  description = "The base number of desired pods."
  default     = 1
}

variable "nginx_image" {
  type        = string
  description = "The Docker image tag for the NGINX container."
  default     = "nginx:latest"
}

variable "container_resources" {
  type = object({
    requests = map(string)
    limits   = map(string)
  })
  description = "The resource requests and limits configuration for the container."
}

variable "service_config" {
  type = object({
    type        = string
    port        = number
    target_port = number
    node_port   = number
    protocol    = string
  })
  description = "Network configuration for the Kubernetes Service."
}


variable "hpa_max_replicas" {
  type        = number
  description = "The maximum number of replicas the HPA can scale up to."
}

variable "hpa_metrics" {
  type = map(number)
  description = "A map of resource metrics to their target average utilization percentages."
}