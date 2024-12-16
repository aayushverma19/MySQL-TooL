variable "region_name" {
  type        = string
  default     = ""
  description = "enter region name"
}
variable "vpc_name" {
  type        = string
  default     = "MySQL-VPC"
  description = "enter vpc name"
}
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/18"
  description = "enter vpc cidr"
}
variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "vpc instance tenancy"
}
variable "dns_support" {
  type        = bool
  default     = true
  description = "vpc dns support"
}
variable "dns_hostnames" {
  type        = bool
  default     = true
  description = "vpc dns hostnames"
}
variable "pub_sub_name" {
  type        = string
  default     = "public-sub"
  description = "enter public subnet name"
}
variable "pub_sub_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "enter pubic subnet cidr"
}
variable "availability_zone01" {
  type        = string
  default     = "us-east-1a"
  description = "enter the availability zone for public subnet"
}
variable "pvt_sub_name1" {
  type        = string
  default     = "Database-sub1"
  description = "enter private subnet1 name"
}
variable "pvt_sub1_cidr" {
  type        = string
  default     = "10.0.3.0/24"
  description = "enter private subnet1 cidr"
}
variable "pvt_sub_name2" {
  type        = string
  default     = "Database-sub2"
  description = "enter private subnet2 name"
}
variable "pvt_sub2_cidr" {
  type        = string
  default     = "10.0.6.0/24"
  description = "enter private subnet2 cidr"
}
variable "availability_zone02" {
  type        = string
  default     = "us-east-1b"
  description = "enter the availability zone for private subnet2"
}
variable "igw_name" {
  type        = string
  default     = "internet_gatewey"
  description = "enter internet gatewey name"
}
variable "NAT_name" {
  type        = string
  default     = "NAT_gatewey"
  description = "enter NAT gatewey name"
}
variable "local_gateway" {
  type        = string
  default     = "local"
  description = "enter local gateway"
}
variable "RT_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "enter route table cidr_block"
}
variable "public_RT_name" {
  type        = string
  default     = "Public-route-table"
  description = "enter Public route table name"
}
variable "private_RT_name" {
  type        = string
  default     = "Private-route-table"
  description = "enter Private route table name"
}
variable "vpc_accept" {
  type        = bool
  default     = true
  description = "description"
}
####################################security
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
variable "pub_sg_name" {
  type        = string
  default     = "public_sg"
  description = "public security group"
}
variable "pub_sg_tag" {
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
variable "pvt_sg_name" {
  type        = string
  default     = "private_sg"
  description = "private security group name"
}
variable "pvt_sg_tag" {
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
variable "tag_nacl" {
  type        = string
  default     = "private_NACL"
  description = "private NACL name"
}

variable "mysql_vpcID" {
  type        = string
  default     = ""
  description = "enter vpi id"
}

###########################################compute

variable "pub_instance" {
  type        = string
  default     = "Bastion_host"
  description = "enter public instance name"
}
variable "tag_name_ec2" {
  type        = string
  default     = "mysql"
  description = "enter tag name of instance"
}
variable "pvt_instance1" {
  type        = string
  default     = "Database-server1"
  description = "enter Database server1 instance name"
}
variable "pvt_instance2" {
  type        = string
  default     = "Database-server2"
  description = "enter Database server2 instance name"
}
variable "ami_id" {
  type        = string
  default     = "ami-0e2c8caa4b6378d8c"
  description = "AMI ID of instanace"
}
variable "pem_key" {
  type        = string
  default     = "nvirinia"
  description = "enter pem key name"
}
variable "pub_ec2_type" {
  type        = string
  default     = "t2.micro"
  description = "enter instance types"
}
variable "pvt_ec2_type" {
  type        = string
  default     = "t2.micro"
  description = "enter instance types"
}
variable "assign_public_IP_pub" {
  type        = bool
  default     = true
  description = "assign_public_IP for private"
}
variable "assign_public_IP_pvt" {
  type        = bool
  default     = false
  description = "assign_public_IP for private"
}
variable "volume_size" {
  type        = number
  default     = 29
  description = "root volume size for the EC2 instances"
}

##########################

variable "tg_name" {
  type        = string
  default     = "Mysql-target"
  description = "target group name"
}
variable "tg_port" {
  type        = number
  default     = 80
  description = "target group port"
}
variable "tg_protocol" {
  type        = string
  default     = "HTTP"
  description = "type of Target protocol"
}
variable "health_check_path" {
  type        = string
  default     = "/"
  description = "enter health check path"
}
variable "health_check_interval" {
  type        = number
  default     = 280
  description = "enter health check interval"
}
variable "health_check_timeout" {
  type        = number
  default     = 5
  description = "enter health check timeout"
}
variable "health_check_threshold" {
  type        = number
  default     = 2
  description = "enter health check healthy threshold"
}
variable "unhealth_check_threshold" {
  type        = number
  default     = 10
  description = "enter health check unhealthy threshold"
}
variable "health_check_matcher" {
  type        = number
  default     = 200
  description = "enter health check matcher"
}
variable "tg_attachment_port" {
  type        = number
  default     = 80
  description = "target group attachment port"
}

#####################


variable "lb_name" {
  type        = string
  default     = "mysql-LB"
  description = "enter load balancer name"
}
variable "lb_internal" {
  type        = bool
  default     = false
  description = "enter load balancer internal"
}
variable "lb_tpye" {
  type        = string
  default     = "application"
  description = "enter load balancer type"
}

variable "lb_enable_deletion" {
  type        = bool
  default     = false
  description = "enter load balancer enable deletion protection"
}

##################################

variable "alb_listener_port" {
  type        = number
  default     = 80
  description = " alb listener port"
}
variable "alb_listener_protocol" {
  type        = string
  default     = "HTTP"
  description = "type of Target protocol"
}
variable "alb_listener_action" {
  type        = string
  default     = "forward"
  description = "type of Target protocol"
}
variable "enable_deletion" {
  type        = bool
  default     = false
  description = "description"
}
