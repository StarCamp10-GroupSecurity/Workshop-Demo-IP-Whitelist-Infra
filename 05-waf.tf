# IP Whitelist set
resource "aws_wafv2_ip_set" "demo_whitelist_set" {
  name               = "demo_whitelist_set"
  description        = "IP set that in the Whitelisting list"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.allow_ip_addresses

  tags = {
    Name = "Whitelist Set"
  }
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = "example-web-acl"
  description = "Example Web ACL"
  scope       = "CLOUDFRONT"
  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "web-acl-metric"
    sampled_requests_enabled   = false
  }

  rule {
    name     = "allow-only-from-allowed-ips"
    priority = 1


    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.demo_whitelist_set.arn
      }


    }

    action {
      allow {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "allow-only-from-allowed-ips-metric"
      sampled_requests_enabled   = false
    }
  }
}

# IP Whitelist set
resource "aws_wafv2_ip_set" "demo_whitelist_set_api" {
  name               = "demo_whitelist_set_api"
  description        = "IP set that in the Whitelisting list"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allow_ip_addresses

  tags = {
    Name = "Whitelist Set"
  }
}

resource "aws_wafv2_web_acl" "web_acl_api" {
  name        = "example-web-acl-api"
  description = "Example Web ACL"
  scope       = "REGIONAL"
  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "web-acl-metric"
    sampled_requests_enabled   = false
  }

  rule {
    name     = "allow-only-from-allowed-ips"
    priority = 1


    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.demo_whitelist_set_api.arn
      }


    }

    action {
      allow {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "allow-only-from-allowed-ips-metric"
      sampled_requests_enabled   = false
    }
  }
}