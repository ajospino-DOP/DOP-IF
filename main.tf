terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "terraformTest" {
  ami = "ami-0a695f0d95cefc163"
  instance_type = "t2.micro"
}