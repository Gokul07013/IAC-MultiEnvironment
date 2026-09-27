terraform {
  backend "s3" {
    bucket       = "rm-state-demo2"
    key          = "iac-multienv/qa/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
