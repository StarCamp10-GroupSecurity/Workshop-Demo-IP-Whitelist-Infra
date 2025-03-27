## Cache Policy
resource "aws_cloudfront_cache_policy" "production" {
  name        = "custom-cache-policy"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host", "Origin", "Referer", "CUSTOM-HEADER"]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

## Origin Request Policy
resource "aws_cloudfront_origin_request_policy" "production" {
  name = "custom-origin-request-policy"
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host", "Origin", "Referer", "CUSTOM-HEADER"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }
}

## Cloud Front Distribution

resource "aws_cloudfront_distribution" "alb_distribution" {
  enabled         = true
  is_ipv6_enabled = false
  price_class     = "PriceClass_100"

  origin {
    domain_name = aws_alb.starcamp_alb.dns_name
    origin_id   = aws_alb.starcamp_alb.id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    origin_shield {
      enabled              = false
      origin_shield_region = var.region
    }
  }

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = aws_alb.starcamp_alb.id
    compress                 = true
    viewer_protocol_policy   = "allow-all"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.production.id
    cache_policy_id          = aws_cloudfront_cache_policy.production.id
  }

  ordered_cache_behavior {
    path_pattern           = "*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_alb.starcamp_alb.id
    viewer_protocol_policy = "redirect-to-https"

    origin_request_policy_id = aws_cloudfront_origin_request_policy.production.id
    cache_policy_id          = aws_cloudfront_cache_policy.production.id

    default_ttl = 86400
    min_ttl     = 0
    max_ttl     = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  depends_on = [aws_alb.starcamp_alb]
}