# terraform {
#   backend "s3" {
#     bucket = "karpenter-convert"
#     key    = "tfstate"
#     region = "ap-south-1"
#   }
# }

terraform {
  backend "local" {
    path = "/opt/tfstate/${terraform.workspace}/poc.tfstate"
  }
}