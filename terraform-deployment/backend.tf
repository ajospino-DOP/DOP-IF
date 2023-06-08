terraform {
  backend "s3"{
    bucket = "dop-app-tfstate"
    key = "main"
    region = "us-east-2"
    dynamodb_table = "dop-dynamo-table"
  }
}