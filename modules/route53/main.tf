data "aws_route53_zone" "domain" {
  name = var.domain_name # Replace with your hosted zone domain
}


resource "aws_route53_record" "ws2" {
  zone_id = data.aws_route53_zone.domain.id
  name    = var.fully_domain_name
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns_name]
}

resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = var.fully_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "example_cert" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.example_cert_validation : record.fqdn]
}