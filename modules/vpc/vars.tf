# Variables for VPC
######################################

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}


# Variables for Security Group
######################################

variable "sg_ingress_cidr_block" {
  description = "CIDR block for the egress rule"
  type        = string
  default     = "0.0.0.0/0"
}

variable "sg_ingress_proto" {
  description = "Protocol used for the ingress rule"
  type        = string
  default     = "tcp"
}

variable "sg_ingress_ssh" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "22"
}

variable "sg_ingress_http" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "80"
}

variable "sg_ingress_https" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "443"
}

variable "sg_egress_proto" {
  description = "Protocol used for the egress rule"
  type        = string
  default     = "-1"
}

variable "sg_egress_all" {
  description = "Port used for the egress rule"
  type        = string
  default     = "0"
}

variable "sg_egress_cidr_block" {
  description = "CIDR block for the egress rule"
  type        = string
  default     = "0.0.0.0/0"
}

# Variables for Subnet
######################################

variable "sbn_public_ip" {
  description = "Assign public IP to the instance launched into the subnet"
  type        = bool
  default     = true
}

# Variables for Route Table
######################################

variable "rt_cidr_block" {
  description = "CIDR block for the route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tenancy" {
  default = "dedicated"
}

variable "vpc_id" {}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}


variable "environment" {}

# Variables for RDS
####################################################
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_region_a" {
  description = "AWS region availability zone"
  type        = string
  default     = "a"
}

variable "aws_region_c" {
  description = "AWS region availability zone"
  type        = string
  default     = "c"
}

variable "sbn_cidr_block_a" {
  description = "CIDR block for the subnet A"
  type        = string
  default     = "10.0.2.0/24"
}

variable "sbn_cidr_block_c" {
  description = "CIDR block for the subnet C"
  type        = string
  default     = "10.0.3.0/24"
} 