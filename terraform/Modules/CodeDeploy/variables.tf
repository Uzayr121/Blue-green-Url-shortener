variable "codedeploy_role" {
  type        = string
  description = "ARN of the CodeDeploy IAM role"
}
variable "aws_service_name" {
  description = "The name of the AWS ECS service"
  type        = string
  default     = "blue-green-app"
}
variable "aws_cluster_name" {
  description = "The name of the AWS ECS cluster"
  type        = string
  default     = "blue-green-cluster"
}
variable "listener_arn" {
  type        = string
  description = "ARN of the ALB listener"

}
variable "blue_tg_name" {
  type        = string
  description = "name of the blue target group"
}
variable "green_tg_name" {
  type        = string
  description = "name of the green target group"
}