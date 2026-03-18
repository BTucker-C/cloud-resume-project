provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "visitor_count" {
  name         = "resume-counter"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_lambda_function" "visitor_counter" {
  function_name = "resume-counter-function"
  role          = "arn:aws:iam::131233419733:role/service-role/resume-counter-function-role-cgnu3sav"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
}

variable "region" {}