variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "pg_password" {
  type        = string
  description = "RDS Postgres Password"
  validation {
    condition     = length(var.pg_password) > 7
    error_message = "The pg_password value must be minimun lenght of 8 characters."
  }
}