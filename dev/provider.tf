terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47"
    }
  }

  required_version = ">= 0.14.11"
}

provider "aws" {
  region = var.aws_region
}
