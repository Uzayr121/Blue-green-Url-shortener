resource "aws_wafv2_web_acl" "main" {
  name        = "alb-waf"
  description = "WAF rules for alb"
  scope       = "REGIONAL" # Use CLOUDFRONT for CloudFront distributions

  default_action {
    allow {} # if traffic doesn't match any rules, allow it by default
  }
  # Add to the web ACL
  rule {
    name     = "rate-limit-overall"
    priority = 5

    action {
      block {} # block requests that exceed the rate limit
    }

    statement {
      rate_based_statement {
        limit              = 2000 # Requests per 5-minute window per IP
        aggregate_key_type = "IP" # Rate limit based on the source IP address
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitMetrics"
      sampled_requests_enabled   = true
    }
  }
  # AWS Core Rule Set - covers common web exploits
  rule {
    name     = "aws-managed-common-rules"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # Exclude rules that cause false positives for your app
        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleMetrics"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "aws-managed-sql-injection"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionMetrics"
      sampled_requests_enabled   = true
    }
  }

  # Known bad inputs
  rule {
    name     = "aws-managed-known-bad-inputs"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputMetrics"
      sampled_requests_enabled   = true
    }
  }


  # Visibility config for the entire Web ACL
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-waf-metrics"
    sampled_requests_enabled   = true
  }
}

# Associate with ALB
resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}