terraform {
  required_version = ">=v1.12.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

provider "kubernetes" {
  host                   = "https://kubernetes.default.svc"
  cluster_ca_certificate = file("${path.module}/.k8s-sa/ca.crt")
  token                  = file("${path.module}/.k8s-sa/token")
}
