terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.61.0"
    }
  }
  backend "s3" {
    bucket = "rm-state-demo"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}
