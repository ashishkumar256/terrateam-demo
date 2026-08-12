locals {
  environment = terraform.workspace
  info        = lookup (var.environment, local.environment, {})
}