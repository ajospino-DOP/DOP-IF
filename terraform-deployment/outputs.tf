output "endpoint_url" {
  description = "CNAME endpoint to the EBS environment"
  value = aws_elastic_beanstalk_environment.eb_env.cname
}