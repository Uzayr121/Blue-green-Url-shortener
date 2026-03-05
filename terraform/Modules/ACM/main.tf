resource "aws_acm_certificate" "cert" {
  domain_name       = "url.uzayr.uk"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.r53_zone_id
}

# Wait for validation to complete
# this block allows us to wait for the certificate to be validated before proceeding with the rest of the infrastructure deployment
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}