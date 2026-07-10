variable "vpc_id" { type = string }
 
resource "aws_security_group" "alb" {
  name   = "mean-sg-alb"
  vpc_id = var.vpc_id
 
  ingress {
    from_port   = 80
    to_port 	= 80
    protocol	= "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port 	= 0
    protocol	= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_security_group" "node" {
  name   = "mean-sg-node"
  vpc_id = var.vpc_id
 
  ingress {
    from_port   	= 80
    to_port     	= 80
    protocol    	= "tcp"
    security_groups = [aws_security_group.alb.id]
  }
 
  egress {
    from_port   = 0
    to_port 	= 0
    protocol	= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_security_group" "mongo" {
  name   = "mean-sg-mongo"
  vpc_id = var.vpc_id
 
  ingress {
    from_port   	= 27017
    to_port     	= 27017
    protocol    	= "tcp"
    security_groups = [aws_security_group.node.id]
  }
 
  egress {
    from_port   = 0
    to_port 	= 0
    protocol	= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}