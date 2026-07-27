terraform {
  backend "s3" {
    bucket                      = "tofu-backend"
    key                         = "${terraform.workspace}/poc.tfstate"
    region                      = "ap-south-1"
    
    # Directs traffic to your LocalStack instance
    endpoint                    = "https://6894ad6c032c-10-244-5-108-31566.papa.r.killercoda.com"
    # Skips AWS-specific verification steps that break locally
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}
