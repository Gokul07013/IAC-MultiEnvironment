# Remote state so CI runners (and your teammates) share the same state.
#
# The bucket (and optional DynamoDB lock table) must exist BEFORE the first
# `terraform init`. Create them once, out of band, e.g.:
#
#   aws s3api create-bucket --bucket <your-tf-state-bucket> --region us-east-1
#   aws s3api put-bucket-versioning --bucket <your-tf-state-bucket> \
#     --versioning-configuration Status=Enabled
#
# Then fill in the bucket name below (and dynamodb_table if you use locking).
terraform {
  backend "s3" {
    bucket       = "CHANGE_ME-tf-state-bucket"
    key          = "iac-multienv/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # S3-native state locking (Terraform >= 1.10)
  }
}
