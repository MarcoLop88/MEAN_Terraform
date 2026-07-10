variable "vpc_id" { type = string }
variable "private_subnet_app" { type = string }
variable "private_subnet_db" { type = string }
variable "node_sg_id" { type = string }
variable "mongo_sg_id" { type = string }
 
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners  	= ["099720109477"]
}
 
resource "aws_instance" "node_app" {
  count              	= 2
  ami                	= data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id          	= var.private_subnet_app
  vpc_security_group_ids = [var.node_sg_id]
  tags               	= { Name = "mean-node-app-${count.index + 1}" }
}
 
resource "aws_instance" "mongodb" {
  ami                	= data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id          	= var.private_subnet_db
  vpc_security_group_ids = [var.mongo_sg_id]
  tags               	= { Name = "mean-mongodb" }
}