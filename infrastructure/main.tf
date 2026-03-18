provider "aws" {
  region = "us-east-2"
}

resource "aws_dynamodb_table" "visitor_count" {
  name         = "resume-visitor-count"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_lambda_function" "visitor_counter" {
  function_name = "resume-visitor-counter"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_iam_role" "lambda_role" {
  name = "resume-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}