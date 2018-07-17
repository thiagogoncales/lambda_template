#IAM Policies required

In order to be able to use `serverless` with AWS, you need to ensure your AWS IAM users have these policies

## Generic Serverless read access
Add this to all users that want to use serverless and any CI client. This only read, so they are harmless.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "NonDestructiveCoreReaderActionsUsedThroughoutServerless",
            "Effect": "Allow",
            "Action": [
                "cloudformation:Describe*",
                "cloudformation:List*",
                "cloudformation:Get*",
                "cloudformation:PreviewStackUpdate",
                "cloudformation:ValidateTemplate",
                "lambda:Get*",
                "lambda:List*",
                "logs:Describe*",
                "logs:Get*",
                "logs:TestMetricFilter",
                "logs:FilterLogEvents",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:List*",
                "apigateway:GET",
                "iam:List*",
                "iam:Get*",
                "iam:Simulate*",
                "kinesis:Describe*",
                "kinesis:List*",
                "dynamodb:Describe*",
                "dynamodb:List*",
                "sqs:List*"
            ],
            "Resource": "*"
        }
    ]
}
```

## Policy for prod deployment
Add this to any CI clients or users that want to deploy to production. Replace `${service_name}` with your project name, defined in `serverless.yml`'s `service`.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ResourceBoundCloudFormationWritersForSlsResourcesProductionDeploy",
            "Effect": "Allow",
            "Action": [
                "cloudformation:Create*",
                "cloudformation:Update*"
            ],
            "Resource": "arn:aws:cloudformation:*:*:stack/${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundIamWritersForSlsFunctionProductionDeploy",
            "Effect": "Allow",
            "Action": "iam:*",
            "Resource": "arn:aws:iam::*:role/${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundDynamoDbStreamWritersForSlsResourcesProductionDeploy",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb::*:table/${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundLambdaWritersForSlsFunctionProductionDeploy",
            "Effect": "Allow",
            "Action": "lambda:*",
            "Resource": "arn:aws:lambda:*:*:function:${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundApiGatewayWritersForSlsEndpointDeploy",
            "Effect": "Allow",
            "Action": "apigateway:*",
            "Resource": [
                "arn:aws:apigateway:*::/restapis",
                "arn:aws:apigateway:*::/restapis/*"
            ]
        },
        {
            "Sid": "ResourceBoundLogWritersForSlsFunctionProductionDeploy",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DeleteLogGroup",
                "logs:DeleteLogStream",
                "logs:DescribeLogStreams",
                "logs:FilterLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${service_name}-production*:log-stream:*"
        },
        {
            "Sid": "ResourceBoundS3ReadsForSlsFunctionNonProductionDeploy",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::${deployment_bucket}"
            ]
        },
        {
            "Sid": "ResourceBoundS3WritersForSlsFunctionProductionDeploy",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${deployment_bucket}/*"
            ]
        }
    ]
}
```

## Policy for dev work
Add this to any developer that should have no write access to production
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ResourceBoundCloudFormationWritersForSlsResourcesNonProductionDeploy",
            "Effect": "Allow",
            "Action": "cloudformation:*",
            "Resource": "arn:aws:cloudformation:*:*:stack/${service_name}-*"
        },
        {
            "Sid": "ResourceDeniedCloudFormationWritersForSlsResourcesProductionDeploy",
            "Effect": "Deny",
            "Action": "cloudformation:*",
            "Resource": "arn:aws:cloudformation:*:*:stack/${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundIamWritersForSlsFunctionNonProductionDeploy",
            "Effect": "Allow",
            "Action": "iam:*",
            "Resource": "arn:aws:iam::*:role/${service_name}-*"
        },
        {
            "Sid": "ResourceDeniedIamWritersForSlsFunctionProductionDeploy",
            "Effect": "Deny",
            "Action": "iam:*",
            "Resource": "arn:aws:iam::*:role/${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundDynamoDbStreamWritersForSlsResourcesNonProductionDeploy",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb::*:table/${service_name}-*"
        },
        {
            "Sid": "ResourceDeniedDynamoDbStreamWritersForSlsResourcesProductionDeploy",
            "Effect": "Deny",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb::*:table/${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundLambdaWritersForSlsFunctionNonProductionDeploy",
            "Effect": "Allow",
            "Action": "lambda:*",
            "Resource": "arn:aws:lambda:*:*:function:${service_name}-*"
        },
        {
            "Sid": "ResourceDeniedLambdaWritersForSlsFunctionProductionDeploy",
            "Effect": "Deny",
            "Action": "lambda:*",
            "Resource": "arn:aws:lambda:*:*:function:${service_name}-production*"
        },
        {
            "Sid": "ResourceBoundApiGatewayWritersForSlsEndpointDeploy",
            "Effect": "Allow",
            "Action": "apigateway:*",
            "Resource": [
                "arn:aws:apigateway:*::/restapis",
                "arn:aws:apigateway:*::/restapis/*"
            ]
        },
        {
            "Sid": "ResourceBoundLogWritersForSlsFunctionNonProductionDeploy",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DeleteLogGroup",
                "logs:DeleteLogStream",
                "logs:DescribeLogStreams",
                "logs:FilterLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${service_name}-*:log-stream:*"
        },
        {
            "Sid": "ResourceDeniedLogWritersForSlsFunctionProductionDeploy",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DeleteLogGroup",
                "logs:DeleteLogStream",
                "logs:DescribeLogStreams",
                "logs:FilterLogEvents"
            ],
            "Effect": "Deny",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${service_name}-production*:log-stream:*"
        },
        {
            "Sid": "ResourceBoundS3ReadsForSlsFunctionNonProductionDeploy",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::${deployment_bucket}"
            ]
        },
        {
            "Sid": "ResourceBoundS3WritersForSlsFunctionNonProductionDeploy",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${deployment_bucket}/*"
            ]
        },
        {
            "Sid": "ResourceDeniedS3WritersForSlsFunctionProductionDeploy",
            "Effect": "Deny",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:DeleteBucket",
                "s3:ListBucketVersions"
            ],
            "Resource": [
                "arn:aws:s3:::${deployment_bucket}/serverless/${service_name}/production*"
            ]
        }
    ]
}
```
