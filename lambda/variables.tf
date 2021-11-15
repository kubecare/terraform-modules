variable "name" {}
variable "lambda_layer_name" { default = "lambda_layer_rds_ca" }
variable "runtime" { default = "nodejs12.x" }
variable "handler" { default = "index.handler" }
variable "source_dir" { default = "" }
variable "source_file" { default = "" }
variable "edge" { default = false }

variable "timeout" { default = 10 }
variable "publish" { default = false }
variable "memory_size" { default = 128 }
variable "reserved_concurrent_executions" { default = -1 }
variable "layers" {
  type    = list
  default = []
}
variable "logs_retention_days" { default = 7 }
variable "logs_destination_lambda_arn" { default = "" }
variable "logs_destination_filter_pattern" { default = "" }
variable "schedule_expression" { default = "" }
variable "notifications_sns_topic_arn" { default = "" }

variable "enable_lambda_insights" { default = false }
variable "enable_lambda_layers_rds_ca" { default = true }
variable "lambda_insights_version" { default = 14 }
variable "lambda_insights_memory_utilization_threshold" { default = 90 }

variable "vpc_subnet_ids" {
  default = []
  type    = list
}
variable "vpc_security_group_ids" {
  default = []
  type    = list
}

variable "invoke_allow_principals" {
  type    = list
  default = []
}

variable "environment" {
  type = map
  default = {
    provisioner = "Terraform"
  }
}

// blank policy to avoid using conditionals
variable "additional_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BlankPolicyToHackTerraformIssues",
      "Effect": "Allow",
      "Action": "sts:GetCallerIdentity",
      "Resource": "*"
    }
  ]
}
EOF
}
variable "attach_policies" {
  type    = list
  default = []
}

variable "assume_role_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

variable "policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:*:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
