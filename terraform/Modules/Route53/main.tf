resource "aws_route53_zone" "primary" {
  name = "url.uzayr.uk"
}

resource "aws_route53_record" "alias" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "url.uzayr.uk"
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}