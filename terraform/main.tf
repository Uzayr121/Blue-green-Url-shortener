module "VPC" {
  source        = "./Modules/VPC"
  ecs_sg        = module.Security-group.ecs_sg
  alb_sg        = module.Security-group.alb_sg
  cloudwatch_sg = module.Security-group.cloudwatch_sg
  ecr_sg        = module.Security-group.ecr_sg

}

module "ALB" {
  source             = "./Modules/ALB"
  alb_sg             = module.Security-group.alb_sg
  public_subnet_id_1 = module.VPC.public_subnet_1_id
  public_subnet_id_2 = module.VPC.public_subnet_2_id
  vpc_id             = module.VPC.vpc_id
  certificate_arn    = module.ACM.certificate_arn

}

module "CodeDeploy" {
  source          = "./Modules/CodeDeploy"
  listener_arn    = module.ALB.listener_arn
  blue_tg_name    = module.ALB.blue_tg_name
  green_tg_name   = module.ALB.green_tg_name
  codedeploy_role = module.IAM.codedeploy_role
  depends_on = [ module.ECS ]
}

module "IAM" {
  source = "./Modules/IAM"

}
module "ECS" {
  source                  = "./Modules/ECS"
  ecs_task_role           = module.IAM.ecs_task_role
  ecs_task_execution_role = module.IAM.ecs_task_execution_role
  private_subnet_1_id     = module.VPC.private_subnet_1_id
  private_subnet_2_id     = module.VPC.private_subnet_2_id
  blue_tg_arn             = module.ALB.blue_tg_arn
  dyanmodb_table_name     = module.DynamoDB.dynamodb_table_name
  ecs_sg                  = module.Security-group.ecs_sg

}
module "DynamoDB" {
  source = "./Modules/DynamoDB"

}

module "Security-group" {
  source = "./Modules/Security-group"
  vpc_id = module.VPC.vpc_id
}


module "Route53" {
  source   = "./Modules/Route53"
  dns_name = module.ALB.dns_name
  zone_id  = module.ALB.zone_id
}

module "WAF" {
  source  = "./Modules/WAF"
  alb_arn = module.ALB.alb_arn
}

module "ACM" {
  source      = "./Modules/ACM"
  r53_zone_id = module.Route53.r53_zone_id

}