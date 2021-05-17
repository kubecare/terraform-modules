variable "notifications_sns_topic_arn" { default = "" }
variable "api_name" { default = "" }
variable "threshold" {default = 10}
variable "period" {default = 60}
variable "evaluation_periods" {default = 1}
variable "alarm_name" {default = ""}

resource "aws_cloudwatch_metric_alarm" "api-4xx" {
  alarm_name                = "api-gateway-4xx-response.${var.alarm_name}"
  alarm_description         = "This alarm monitors api 4xx response"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "4XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = var.period
  statistic                 = "Sum"
  threshold                 = var.threshold
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  dimensions = {
    ApiName = var.api_name
  }
}

resource "aws_cloudwatch_metric_alarm" "api-5xx" {
  alarm_name                = "api-gateway-5xx-response.${var.alarm_name}"
  alarm_description         = "This alarm monitors api 5xx response"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "5XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = var.period
  statistic                 = "Sum"
  threshold                 = var.threshold
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  dimensions = {
    ApiName = var.api_name
  }
}


