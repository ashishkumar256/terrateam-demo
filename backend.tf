terraform {
  backend "s3" {
    bucket                      = "tofu-backend"
    key                         = "${terraform.workspace}/poc.tfstate"
    region                      = "ap-south-1"
    
    # Directs traffic to your LocalStack instance
    endpoint                    = "https://dcaddf5ad2ff-10-244-8-192-31566.spca.r.killercoda.com"
    # Skips AWS-specific verification steps that break locally
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}
