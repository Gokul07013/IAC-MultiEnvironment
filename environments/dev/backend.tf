terraform {
  backend "s3" {
    bucket       = "rm-state-demo"
    key          = "iac-multienv/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
