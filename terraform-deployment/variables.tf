variable "region" {
  description = "AWS region for resources"
  type = string
  default = "us-east-2"
}

variable "image_repository_url" {
  description = "URL of Application image"
  type = string
  default = "467346434923.dkr.ecr.us-east-2.amazonaws.com/dop"
}

variable "container_port" {
  description = "Container application port"
  type = number
  default = 8060 
}