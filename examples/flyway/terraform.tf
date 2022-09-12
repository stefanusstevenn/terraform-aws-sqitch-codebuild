terraform {
  backend "s3" {
    bucket         = "default-terraform-state-ap-southeast-1-146534595588"
    dynamodb_table = "default-terraform-state-ap-southeast-1-146534595588"
    key            = "ap-southeast-1/codebuild-sqitch-deploy/dummy-rds-postgres-deploy/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}
