output "node_instances_ids" { value = aws_instance.node_app[*].id }
output "nodejs_public_ips" { value = aws_instance.node_app[*].public_ip }
output "nodejs_private_ips" { value = aws_instance.node_app[*].private_ip }
output "mongodb_private_ip" { value = aws_instance.mongodb.private_ip }