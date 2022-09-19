variable "ec2_count" {
  default = "1"
}

variable "ami_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {}

variable "security_groups" {
  type = string
}

variable "environment" {}



variable "root_device_type" {
  description = "Type of the root block device"
  type        = string
  default     = "gp2"
}

variable "root_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "30"
}
