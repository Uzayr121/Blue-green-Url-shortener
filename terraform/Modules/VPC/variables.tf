variable "ecs_sg" {
  type        = string
  description = "id of ecs security group"
}
variable "alb_sg" {
  type        = string
  description = "id of alb security group"
}
variable "cloudwatch_sg" {
  type        = string
  description = "id of cloudwatch security group"
}
variable "ecr_sg" {
  type        = string
  description = "id of ecr security group"
}