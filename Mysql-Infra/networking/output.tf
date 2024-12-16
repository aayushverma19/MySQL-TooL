# output "default_vpc_id" {
#   value = data.aws_vpc.default.id
# }
# output "default_vpc_cidr" {
#   value = data.aws_vpc.default.cidr_block
# }
# output "default_mainRT" {
#   value = data.aws_vpc.default.main_route_table_id
# }
output "vpc_id" {
  value       = aws_vpc.mysql.id
  description = "id of the mysql vpc "
}
output "pub_subnet_id" {
  value       = aws_subnet.public-subnet.id
  description = "id of the public subnet "
}
output "pvt_subnet1_id" {
  value       = aws_subnet.pvt-subnet1.id
  description = "id of the public subnet "
}
output "pvt_subnet2_id" {
  value       = aws_subnet.pvt-subnet2.id
  description = "id of the public subnet "
}
