output "nodejs_public_ips" { value = module.compute.nodejs_public_ips }
output "nodejs_private_ips" { value = module.compute.nodejs_private_ips }
output "mongodb_private_ip" { value = module.compute.mongodb_private_ip }
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "nat_gateway_public_ip" { value = module.vpc.nat_gateway_public_ip }