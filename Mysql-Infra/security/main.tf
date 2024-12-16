#######################################################################
####            security module (security group)
#######################################################################

resource "aws_security_group" "public_sgroups" {
  name   = var.pub_sg_name
  vpc_id = var.VPC_ID  

  dynamic "ingress" {
    for_each = var.public_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.public_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = egress.value.description
    }
  }

  tags = {
    Name = var.pub_sg_tag
  }
}

resource "aws_security_group" "private_sg" {
  name   = var.pvt_sg_name
  vpc_id = var.VPC_ID  

  dynamic "ingress" {
    for_each = var.private_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.private_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = egress.value.description
    }
  }

  tags = {
    Name = var.pvt_sg_tag
  }
}


#######################################################################
####            Nacl
#######################################################################

resource "aws_network_acl" "naclpvt" {
  vpc_id = var.VPC_ID  

  # Ingress rule using the variable
  ingress {
    protocol   = var.ingress_rule_nacl.protocol
    rule_no    = var.ingress_rule_nacl.rule_no
    action     = var.ingress_rule_nacl.action
    cidr_block = var.ingress_rule_nacl.cidr_block
    from_port  = var.ingress_rule_nacl.from_port
    to_port    = var.ingress_rule_nacl.to_port
  }

    # Egress rule using the variable
  egress {
    protocol   = var.egress_rule_nacl.protocol
    rule_no    = var.egress_rule_nacl.rule_no
    action     = var.egress_rule_nacl.action
    cidr_block = var.egress_rule_nacl.cidr_block
    from_port  = var.egress_rule_nacl.from_port
    to_port    = var.egress_rule_nacl.to_port
  }

  tags = {
    Name = var.tag_nacl
  }
}

###### nacl association pvt1
resource "aws_network_acl_association" "pvt1" {
  network_acl_id = aws_network_acl.naclpvt.id
  subnet_id      = var.pvt_sub1_id
}

###### nacl association pvt2
resource "aws_network_acl_association" "pv2" {
  network_acl_id = aws_network_acl.naclpvt.id
  subnet_id      = var.pvt_sub2_id
}

