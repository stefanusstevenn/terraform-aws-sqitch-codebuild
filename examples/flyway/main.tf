module "codebuild_sqitch" {
  source = "../../"
  
  product_domain  = "${local.product_domain}"
  description     = "CodeBuild project for deploying sqitch project to dummy-rds-postgres"
  pipeline_name   = "dummy-rds-postgres"
  environment     = "production"
  
  vpc_id                 = "${data.terraform_remote_state.vpc_lab_production.outputs.vpc_id}"
  vpc_subnet_app_ids     = "${data.terraform_remote_state.vpc_lab_production.outputs.subnet_app_ids}"
  codebuild_sqitch_sg_id = "${data.terraform_remote_state.codebuild_sqitch_shared_resources.outputs.codebuild_security_group_id}"
  codebuild_role_arn     = "${data.terraform_remote_state.codebuild_sqitch_shared_resources.outputs.codebuild_role_arn}"
  
  sqitch_project_repository     = "https://github.com/traveloka/bei-postgres-template.git"
  password_parameter_store_path = "/tvlk-secret/codebuild/bei/example-pg-password"
  sqitch_project_path           = "example-logical-db/example-flyway-project"

  environment_variables = [
    {
      name  = "SLACK_NOTIFICATION_LAMBDA"
      value = "bei-database-deployment-lambda"
      type  = "PLAINTEXT"
    },
    {
      name  = "FLYWAY_URL"
      value = "jdbc:postgresql://dummy-rds-postgres.cktgjw0wumfo.ap-southeast-1.rds.amazonaws.com:5432/example"
      type  = "PLAINTEXT"
    },
    {
      name  = "FLYWAY_USER"
      value = "example_user"
      type  = "PLAINTEXT"
    },
    {
      name  = "FLYWAY_PASSWORD"
      value = "/tvlk-secret/codebuild/bei/example-pg-password"
      type  = "PARAMETER_STORE"
    }
  ]

  buildspec = "${data.template_file.buildspec.rendered}"
}
