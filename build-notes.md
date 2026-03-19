# Build Notes

## Day 1

Created project structure and initialized Git repository.

## Day 2

Setup S3 Hosting
    S3 Hosting
        Created an S3 Bucket: brandon-tucker-resume with us-east-2 (Ohio) as the region
            \\Bucket used to host static website objects.

        Enabled static website hosting
            \\Configured index.html as the root document.

        Configured bucket policy
            \\Allowed public read access using s3:GetObject so browsers can retrieve site files.

Setup CloudFront Distribution
    CloudFront CDN
        Origin configured: brandon-tucker-resume S3 bucket
            \\Configured CloudFront origin to retrieve content from S3.

        Enabled private S3 bucket access
            \\Created an Origin Access Control (OAC) allowing CloudFront to access the bucket securely.

        Distribution root object configured: index.html
            \\Requests to the domain root resolve to the homepage file stored in S3.

        CloudFront deployment completed after configuration
            \\Website now accessible through CloudFront CDN with HTTPS support.

Attach and Configure Custom Domain, DNS, and TLS
    Domain Registration
        Via Route53 - registered domain: brandon-tucker.com
            \\Route53 also created a hosted zone for DNS management.

    SSL Certificate Creation
        Via AWS Certificate Manager (ACM)
            \\DNS validation used with CNAME records automatically inserted into Route53.

            Certificate requested for:
                brandon-tucker.com
                    \\Primary domain

                *.brandon-tucker.com
                    \\Wildcard certificate allowing future subdomains

    CloudFront CDN Update
        Added alternate domain name (CNAME): resume.brandon-tucker.com
            \\Allows CloudFront distribution to respond to the custom domain.

        ACM certificate attached
            \\Enables CloudFront to authenticate the domain and serve content over HTTPS.

    DNS Configuration
        Via Route53
            Record type: A
            Record name: resume
            Alias target: CloudFront distribution
                \\Routes traffic from resume.brandon-tucker.com to the CloudFront CDN.

OUTCOME:
    Resume site is now accessible through a custom domain:
        https://resume.brandon-tucker.com

AWS Services used thus far:
    IAM
    Amazon S3
    Amazon CloudFront
    Amazon Route53
    AWS Certificate Manager (ACM)

## Day 3

Setup DynamoDB
    Created DynamoDB table: resume-counter with partition key id (String)
        \\Table used to store persistent visitor count.
    Inserted initial item:  
        id: visitors  
        count: 0  
        \\Initial record used to track and increment visitor count.

Setup Lambda Function and IAM Permissions
    IAM Role
        Identified Lambada execution role
            \\Role assumed by Lambda during execution.
        Created and attached inline policy  
            \\Granted permissions for DynamoDB access.

        Permissions configured:  
        dynamodb:GetItem  
        dynamodb:UpdateItem  
            \\Allows Lambda to read and update visitor count in DynamoDB.

        Scoped permissions to resume-counter table  
            \\Ensures least-privilege access.
    
    AWS Lambda
        Created Lambda function: resume-counter-function using Python runtime  
            \\Handles logic for retrieving and updating visitor count.

        Integrated DynamoDB using boto3  
            \\Enables interaction between Lambda and DynamoDB.

        Implemented initial logic  
            \\Reads current count, increments value, and writes updated value back.

        Encountered serialization issue  
            \\DynamoDB returned count as Decimal, causing JSON serialization failure.

        Resolved issue by converting value to int  
            \\Ensures compatibility when returning JSON response.
        
Improve Counter Logic
    DynamoDB Update Expression
        \\Replaced read-modify-write pattern.

    Configured UpdateExpression: ADD  
        \\Increments count directly within DynamoDB.

    Configured ReturnValues: UPDATED_NEW  
        \\Returns updated value after increment operation.

    Result  
        \\Prevents race conditions and ensures accurate counting under concurrent access.

Setup API Gateway
    API Gateway (HTTP API)
        \\Provides public endpoint for frontend requests

    Integrated API with Lambda function  
        \\Routes incoming requests to Lambda for processing.

     Configured route: GET /count  
        \\Defines endpoint used to retrieve and increment visitor count.

    Enabled CORS  
         \\Allows requests from browser-based frontend hosted on CloudFront.

Connect Frontend to Backend
    Added JavaScript fetch request to API endpoint
        \\Retrieves visitor count from API Gateway.

    Parsed JSON response and updated HTML element  
        \\Displays live visitor count on resume page.

OUTCOME:
    Resume site now includes a dynamic visitor counter powered by a serverless backend.

AWS Services used thus far:
IAM
Amazon S3
Amazon CloudFront
Amazon Route53
AWS Certificate Manager (ACM)
AWS Lambda
Amazon DynamoDB
Amazon API Gateway

## Day 4

Setup Terraform & Initialize Project
    Installed Terraform locally and configured system PATH for CLI access
    Initialized Terraform workspace using: terraform init

Configure AWS Authentication
    Generated IAM access keys via AWS IAM user
    Configured local credentials using: aws configure

Define Initial Terraform Resources
    Created main.tf with:
        DynamoDB table resource
        Lambda function resource

    Introduced variable-driven configuration:
        Declared variables in .tf
        Assigned values via terraform.tfvars

Import Existing AWS Resources into Terraform State
    Imported DynamoDB table:
        terraform import aws_dynamodb_table.visitor_count resume-counter
    
    Imported Lambda function:
        terraform import aws_lambda_function.visitor_counter resume-counter-function
    
Lambda Packaging Integration
    Packaged Lambda function into deployment artifact:
        zip lambda.zip lambda_function.py

    Integrated with Terraform:
        filename         = "lambda.zip"
        source_code_hash = filebase64sha256("lambda.zip")\
            \\Terraform detects changes via hash - triggers in-place Lambda updates

Outcome:
    Transitioned infrastructure from manual AWS setup to Terraform-managed configuration.
    
AWS Services used thus far:
IAM
Amazon S3
Amazon CloudFront
Amazon Route53
AWS Certificate Manager (ACM)
AWS Lambda
Amazon DynamoDB
Amazon API Gateway