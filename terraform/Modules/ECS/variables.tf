variable "ecs_cluster_name" {
  type        = string
  description = "name of the ECS cluster"
  default     = "blue-green-cluster"

}
variable "dyanmodb_table_name" {
  type        = string
  description = "name of the DynamoDB table"
}
variable "ecs_task_role" {
  type        = string
  description = "ARN of the IAM role for ECS tasks"
}
variable "ecs_task_execution_role" {
  type        = string
  description = "ARN of the IAM role for ECS task execution"
}

variable "private_subnet_1_id" {
  type        = string
  description = "id of private subnet 1"
}
variable "private_subnet_2_id" {
  type        = string
  description = "id of private subnet 2"
}

variable "container_name" {
  type        = string
  description = "name of the container in the ECS task definition"
  default     = "app"

}
variable "blue_tg_arn" {
  type        = string
  description = "target group ARN of the blue deployment"
}
variable "ecs_service_name" {
  default     = "blue-green-app"
  type        = string
  description = "name of the ECS service"
}
variable "ecs_sg" {
  type        = string
  description = "security group for the ECS service"

}