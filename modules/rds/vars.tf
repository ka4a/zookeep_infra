variable "rds_ingress_cidr" {
  type = list
  default = ["10.0.0.0/16"]
}

variable "publicly_accessible" {
  default     = "false"
  description = "Public access for RDS"
}

variable "identifier" {
  default     = "mydb-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.21"
    postgres = "10.15"
  }
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "mydb"
  description = "db name"
}

variable "username" {
  default     = "myuser"
  description = "User name"
}

variable "password" {
  description = "password, provide through your ENV variables"
}

variable "private_net_ids" {
  type        = list(any)
  description = "List of IDs of private subnets"
}

variable "environment" {}

variable "vpc_id" {}

variable "max_allocated_storage" {
  default = 100
}