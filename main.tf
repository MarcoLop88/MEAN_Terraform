Terraform
provider "aws" {
  region = var.aws_region
}
 
module "vpc" {
  source = "./modules/vpc"
}
 
module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}
 
module "alb" {
  source         	= "./modules/alb"
  vpc_id         	= module.vpc.vpc_id
  public_subnets_ids = module.vpc.public_subnets_ids
  alb_sg_id      	= module.security.alb_sg_id
  node_instances_ids = module.compute.node_instances_ids
}
 
module "compute" {
  source         	= "./modules/compute"
  vpc_id         	= module.vpc.vpc_id
  private_subnet_app = module.vpc.private_subnet_app_id
  private_subnet_db  = module.vpc.private_subnet_db_id
  node_sg_id     	= module.security.node_sg_id
  mongo_sg_id    	= module.security.mongo_sg_id
}