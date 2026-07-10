Terraform
variable "vpc_id" { type = string }
variable "public_subnets_ids" { type = list(string) }
variable "alb_sg_id" { type = string }
variable "node_instances_ids" { type = list(string) }
 
resource "aws_lb" "alb" {
  name           	= "mean-alb"
  internal       	= false
  load_balancer_type = "application"
  security_groups	= [var.alb_sg_id]
  subnets        	= var.public_subnets_ids
}
 
resource "aws_lb_target_group" "tg" {
  name 	= "mean-node-tg"
  port 	= 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path            	= "/"
    interval        	= 30
    timeout         	= 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port          	= "80"
  protocol      	= "HTTP"
  default_action {
    type         	= "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
 
resource "aws_lb_target_group_attachment" "app" {
  count            = length(var.node_instances_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id    	= var.node_instances_ids[count.index]
  port         	= 80
}