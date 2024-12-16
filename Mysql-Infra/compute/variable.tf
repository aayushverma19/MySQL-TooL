variable "pub_instance" {
  type        = string
  default     = "Bastion_host"
  description = "enter public instance name"
}
variable "tag_name_instance" {
  type        = string
  default     = "pub-mysql"
  description = "enter tag name of instance"
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
variable "key" {
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
  type        = string
  default     = "200-299"
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
variable enable_deletion {
  type        = bool
  default     = false
  description = "description"
}

#####################################module
variable "pub_sub_id" {
  type        = string
  default     = ""
  description = "public subnet id pick from networking module"
}
variable "pvt_sub1_id" {
  type        = string
  default     = ""
  description = "private subnet1 id pick from networking module"
}
variable "pvt_sub2_id" {
  type        = string
  default     = ""
  description = "private subnet2 id pick from networking module"
}
variable "pub_sg" {
  type        = string
  default     = ""
  description = "public group id pick from networking module"
}
variable "pvt_sg" {
  type        = string
  default     = ""
  description = "private group id pick from networking module"
}
variable "VPC_ID" {
  type        = string
  default     = ""
  description = "private group id pick from networking module"
}

