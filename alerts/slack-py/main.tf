module "lambda" {
  source = "../../lambda"

  name        = "slack-alarm-notification"
  source_dir  = var.source_dir
  runtime     = "python3.8"
  handler     = "sns_slack.lambda_handler"
  memory_size = 128
  timeout     = 30

  environment = {
    "SLACK_URL"     = var.slack_url
    "SLACK_CHANNEL" = var.slack_channel
    "SLACK_USER"    = var.slack_user
  }

  invoke_allow_principals = [
    "sns.amazonaws.com",
  ]
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = module.lambda.arn
}
