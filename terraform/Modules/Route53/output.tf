output "nameserver" {
  value = aws_route53_zone.primary.name_servers
}
output "r53_zone_id" {
  value = aws_route53_zone.primary.zone_id

}