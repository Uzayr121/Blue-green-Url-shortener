variable "alb_sg" {
  type        = string
  description = "id of alb security group"
}
variable "public_subnet_id_1" {
  type        = string
  description = "id of public subnet 1"
}
variable "public_subnet_id_2" {
  type        = string
  description = "id of public subnet 2"
}
variable "vpc_id" {
  type        = string
  description = "id of the VPC"

}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for HTTPS listener"

}