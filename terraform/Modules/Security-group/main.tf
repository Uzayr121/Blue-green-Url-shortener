resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id #variable for VPC id
  name   = "alb_sg"   # variable for security group name
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

}


resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb_sg.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_sg.id

}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id #variable for VPC id
  name   = "ecs_sg"   # variable for security group name
}

resource "aws_vpc_security_group_ingress_rule" "ecs_to_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id

}
resource "aws_vpc_security_group_egress_rule" "s3_access" {
  security_group_id = aws_security_group.ecs_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  prefix_list_id    = "pl-7ca54015" # prefix list for s3 access

}
resource "aws_vpc_security_group_egress_rule" "dynamo_access" {
  security_group_id = aws_security_group.ecs_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  prefix_list_id    = "pl-b3a742da" # prefix list for dynamo_DB access

}

resource "aws_vpc_security_group_egress_rule" "ecr_access" {
  security_group_id            = aws_security_group.ecs_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecr_sg.id


}
resource "aws_vpc_security_group_egress_rule" "cloudwatch_access" {
  security_group_id            = aws_security_group.ecs_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.log_sg.id
}


resource "aws_security_group" "ecr_sg" {
  vpc_id = var.vpc_id #variable for VPC id
  name   = "ecr_sg"   # variable for security group name
}
resource "aws_vpc_security_group_ingress_rule" "ecr_ingress" {
  security_group_id            = aws_security_group.ecr_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_sg.id

}

resource "aws_vpc_security_group_egress_rule" "ecr_egress" {
  security_group_id = aws_security_group.ecr_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

}


resource "aws_security_group" "log_sg" {
  vpc_id = var.vpc_id #variable for VPC id
  name   = "log_sg"   # security group name
}

resource "aws_vpc_security_group_ingress_rule" "log_ingress" {
  security_group_id            = aws_security_group.log_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_sg.id

}

resource "aws_vpc_security_group_egress_rule" "log_egress" {
  security_group_id = aws_security_group.log_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

}


