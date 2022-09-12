data "terraform_remote_state" "vpc_lab_production" {
  backend = "s3"

  config = {
    bucket         = "default-terraform-state-ap-southeast-1-146534595588"
    dynamodb_table = "default-terraform-state-ap-southeast-1-146534595588"
    key            = "ap-southeast-1/general/vpc/lab-production/terraform.tfstate"
    region         = "ap-southeast-1"
  }
}

data "terraform_remote_state" "codebuild_sqitch_shared_resources" {
  backend = "s3"

  config = {
    bucket         = "default-terraform-state-ap-southeast-1-146534595588"
    dynamodb_table = "default-terraform-state-ap-southeast-1-146534595588"
    key            = "ap-southeast-1/codebuild-sqitch-shared-resources/bei/terraform.tfstate"
    region         = "ap-southeast-1"
  }
}

data "template_file" "buildspec" {
  template = <<EOF
version: 0.2
phases:
  pre_build:
    commands:
      - ./scripts/assume_role.sh -r arn:aws:iam::015110552125:role/BeiartfWriter_$${product_domain}
  build:
    commands: 
      - ./scripts/sqitch_codebuild.sh
  post_build:
    commands:
      - ./scripts/notif_slack_channel.sh
artifacts:
  files:
    - '**/*'
EOF

  vars = {
    product_domain = "${local.product_domain}" 
  }
}
