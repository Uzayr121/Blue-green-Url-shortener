variable "iam_role_name" {
  type        = string
  description = "name of the IAM role for ECS task execution"
  default     = "task-def"

}
variable "task_def_arn" {
  type        = string
  description = "ARN of the task definition to run"
  default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

variable "code_deploy_arn" {
  type        = string
  description = "ARN of code deploy role"
  default     = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

variable "codedeploy_role_name" {
  type        = string
  description = "name of the CodeDeploy IAM role"
  default     = "ecs-codedeploy-role"
}

variable "task_role_name" {
  type        = string
  description = "name of the IAM role for ECS tasks"
  default     = "ecs-task-role"
}

variable "cloudwatch_policy_name" {
  type        = string
  description = "name of the IAM policy for CloudWatch access"
  default     = "ecs-cloudwatch-policy"

}