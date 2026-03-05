output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}
output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
output "cloudwatch_sg" {
  value = aws_security_group.log_sg.id
}
output "ecr_sg" {
  value = aws_security_group.ecr_sg.id
}