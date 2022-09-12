output "codebuild_arn" {
  value       = "${module.codebuild_sqitch.codebuild_arn}"
  description = "The pipeline's ARN"
}
