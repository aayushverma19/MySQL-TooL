output "pub_SG_id" {
  value       = aws_security_group.public_sgroups.id
  description = "id of the public security group "
}

output "pvt_SG_id" {
  value       = aws_security_group.private_sg.id
  description = "id of the private security group "
}

output "pvt_NACL_id" {
  value       = aws_network_acl.naclpvt.id
  description = "id of the private NACL"
}
