terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = var.region
}

resource "local_file" "docker_run_config" {
  content = jsonencode({
    "AWSEBDockerrunVersion": "3", 
    "name":"dop",
    "image":{       
      "Name": "${var.image_repository_url}:latest"     
    },     
      "ports": [       {         
        "ContainerPort": var.container_port,
        "hostPort": var.container_port
      }     
    ],   
  })
  filename = "${path.module}/Dockerrun.aws.json"
}

resource "aws_s3_bucket" "docker_run_bucket" {
  bucket = "docker-run-bucket"
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
    key = "${local_file.docker_run_config.content}.zip"
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