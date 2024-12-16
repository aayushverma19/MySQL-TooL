variable "public_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))

  default = [
    { from_port = 22, to_port = 22, protocol = "tcp", description = "SSH" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "HTTP" },
    { from_port = 3306, to_port = 3306, protocol = "tcp", description = "MySQL" },
    { from_port = 443, to_port = 443, protocol = "tcp", description = "HTTPS" },
    { from_port = 0, to_port = 0, protocol = "-1", description = "All Inbound" }
  ]
}
variable "public_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))

  default = [
    { from_port = 0, to_port = 0, protocol = "-1", description = "All Inbound" }
  ]
}
variable pub_sg_name {
  type        = string
  default     = "public_sg"
  description = "public security group"
}
variable pub_sg_tag {
  type        = string
  default     = "public_Sgroup"
  description = "public security group"
}
variable "private_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))

  default = [
    { from_port = 22, to_port = 22, protocol = "tcp", description = "SSH" },
    { from_port = 3306, to_port = 3306, protocol = "tcp", description = "MySQL" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "HTTP" },
    { from_port = 443, to_port = 443, protocol = "tcp", description = "HTTPS" },
    { from_port = 0, to_port = 0, protocol = "-1", description = "All Inbound" }
  ]
}
variable "private_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))

  default = [
    { from_port = 0, to_port = 0, protocol = "-1", description = "All Inbound" }
  ]
}
variable pvt_sg_name {
  type        = string
  default     = "private_sg"
  description = "private security group name"
}
variable pvt_sg_tag {
  type        = string
  default     = "private_Sgroup"
  description = "private security group tag"
}

variable "egress_rule_nacl" {
  description = "Egress rule configuration for NACL"
  type = object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  })
  default = {
    protocol   = "all"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

variable "ingress_rule_nacl" {
  description = "ingress rule configuration for NACL"
  type = object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  })
  default = {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
variable tag_nacl {
  type        = string
  default     = "private_NACL"
  description = "private NACL name"
}

variable VPC_ID {
  type        = string
  default     = ""
  description = "vpi id pick from networking module"
}
variable pvt_sub1_id {
  type        = string
  default     = ""
  description = "private subnet1 id pick from networking module"
}
variable pvt_sub2_id {
  type        = string
  default     = ""
  description = "private subnet2 id pick from networking module"
}

