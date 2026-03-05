output "blue_tg_arn" {
  value = aws_lb_target_group.blue-tg.arn
}
output "listener_arn" {
  value = aws_lb_listener.http_listener.arn
}
output "blue_tg_name" {
  value = aws_lb_target_group.blue-tg.name
}
output "green_tg_name" {
  value = aws_lb_target_group.green-tg.name
}
output "alb_arn" {
  value = aws_lb.test.arn
}

output "zone_id" {
  value = aws_lb.test.zone_id

}
output "dns_name" {
  value = aws_lb.test.dns_name

}