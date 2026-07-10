output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets_ids" { value = [aws_subnet.pub_1.id, aws_subnet.pub_2.id] }
output "private_subnet_app_id" { value = aws_subnet.priv_app.id }
output "private_subnet_db_id" { value = aws_subnet.priv_db.id }
output "nat_gateway_public_ip" { value = aws_eip.nat.public_ip }