resource "local_file" "docker_run_config" {
  content = jsonencode({
    "AWSEBDockerrunVersion":"1",
    "name": "dop", 
    "Image":{       
      "Name":"${var.image_repository_url}:latest"     
    },     
    "Ports":[{         
      "ContainerPort" = var.container_port,
      "HostPort" = var.container_port
    }]   
  })
  
  filename = "${path.module}/Dockerrun.aws.json"
}

resource "aws_s3_bucket" "docker_run_bucket" {
  bucket = "docker-run-bucket-dop"
  tags = local.tags
}

resource "aws_s3_bucket_ownership_controls" "docker_run_bucket_ownership" {
  bucket = aws_s3_bucket.docker_run_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "docker_run_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.docker_run_bucket_ownership]

  bucket = aws_s3_bucket.docker_run_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_object" "docker_run_object" {
    key = "${local.docker_run_config_sha}.zip"
    bucket = aws_s3_bucket.docker_run_bucket.id
    source = data.archive_file.docker_run.output_path
  tags = local.tags
}

resource "aws_iam_instance_profile" "ec2_eb_profile" {
  name = "event-driven-ec2-profile"
  role = aws_iam_role.ec2_role.name
  tags = local.tags
}

resource "aws_iam_role" "ec2_role" {
  name = "event-driven-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [ 
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
   ]
  inline_policy {
    name = "eb-application-permissions"
    policy = data.aws_iam_policy_document.permissions.json
  }
  tags = local.tags
}

resource "aws_elastic_beanstalk_application" "eb_app" {
  name = "dop"
  description = "DOP application deployment"
  tags = local.tags
}

resource "aws_elastic_beanstalk_application_version" "eb_app_version" {
  name = local.docker_run_config_sha
  application = aws_elastic_beanstalk_application.eb_app.name
  description = "application version created by terraform"
  bucket = aws_s3_bucket.docker_run_bucket.id
  key = aws_s3_bucket_object.docker_run_object.id
  tags = local.tags
}

resource "aws_elastic_beanstalk_environment" "eb_env" {
  name = "dop-env"
  application = aws_elastic_beanstalk_application.eb_app.name
  platform_arn = "arn:aws:elasticbeanstalk:${var.region}::platform/Docker running on 64bit Amazon Linux 2/3.5.8"
  version_label = aws_elastic_beanstalk_application_version.eb_app_version.name
  cname_prefix = "dop-app"
  tags = local.tags

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = aws_iam_instance_profile.ec2_eb_profile.name
  }
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = var.max_instance_count
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "internet facing"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "MatcherHTTPCode"
    value = 200
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "HealthCheckPath"
    value = "/docs"
  }
}