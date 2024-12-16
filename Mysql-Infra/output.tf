# output "default_vpc_id" {
#   value = module.Netwoking.default_vpc_id
# }
# output "default_vpc_cidr" {
#   value = data.aws_vpc.default.cidr_block
# }
# output "default_mainrt" {
#   value = data.aws_vpc.default.main_route_table_id
# }
output "vpc_id" {
  value       = module.Netwoking.vpc_id
  description = "id of the mysql vpc "
}
output "pub_subnet_id" {
  value       = module.Netwoking.pub_subnet_id
  description = "id of the public subnet "
}
output "pvt_subnet1_id" {
  value       = module.Netwoking.pvt_subnet1_id
  description = "id of the public subnet "
}
output "pvt_subnet2_id" {
  value       = module.Netwoking.pvt_subnet2_id
  description = "id of the public subnet "
}
##############

output "pub_SG_id" {
  value       = module.Security.pub_SG_id
  description = "id of the public security group "
}

output "pvt_SG_id" {
  value       = module.Security.pvt_SG_id
  description = "id of the private security group "
}

output "pvt_NACL_id" {
  value       = module.Security.pvt_NACL_id
  description = "id of the private NACL"
}

##############

output "pub_instance_id" {
  value       = module.Compute.pub_instance_id
  description = "id of the public instance "
}
output "pvt_instance1_id" {
  value       = module.Compute.pvt_instance1_id
  description = "id of the private instance1 "
}
output "pvt_instance2_id" {
  value       = module.Compute.pvt_instance2_id
  description = "id of the private instance2"
}
output "Bastion_Public_IP" {
  value       = module.Compute.Bastion_Public_IP
  description = "Public IP address of the bastion EC2 instance"
}
output "load_balancer_DNS" {
  value       = module.Compute.load_balancer_DNS
  description = "DNS name of load balancer"
}
