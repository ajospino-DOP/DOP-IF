terraform {
  backend "s3"{
    bucket = "dop-app-tfstate"
    key = "main"
    region = var.region
    dynamodb_table = "dop-dynamo-table"
  }
}